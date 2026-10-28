#!/data/data/com.termux/files/usr/bin/python3
"""Print this phone's wireless-debugging ports, discovered over mDNS.

  adb-port.py          ports advertised for _adb-tls-connect, one per line
  adb-port.py --pair   ports advertised for _adb-tls-pairing, only while the
                       "Pair device with pairing code" dialog is open

Exits 1 when nothing answers. Uses only the standard library.
"""

import socket
import struct
import sys
import time

GROUP = "224.0.0.251"
PORT = 5353
CONNECT = "_adb-tls-connect._tcp.local"
PAIR = "_adb-tls-pairing._tcp.local"
T_PTR, T_SRV = 12, 33
QUIET = 0.3  # after the first answer, how long to keep listening for others


def read_name(packet, offset):
    """Return (dotted name, offset just past it), following compression pointers."""
    labels, resume = [], None
    while offset < len(packet) and packet[offset]:
        length = packet[offset]
        if length & 0xC0 == 0xC0:  # pointer: jump, but remember where to resume
            if resume is None:
                resume = offset + 2
            target = struct.unpack(">H", packet[offset : offset + 2])[0] & 0x3FFF
            if target >= offset:  # pointers point backwards; this also stops loops
                break
            offset = target
            continue
        labels.append(packet[offset + 1 : offset + 1 + length].decode("latin1"))
        offset += 1 + length
    return ".".join(labels), (resume if resume is not None else offset + 1)


def srv_ports(packet):
    """Yield (service name, port) for each SRV record in a DNS response."""
    questions, answers, authorities, additional = struct.unpack(">HHHH", packet[4:12])
    offset = 12
    for _ in range(questions):
        _, offset = read_name(packet, offset)
        offset += 4
    for _ in range(answers + authorities + additional):
        name, offset = read_name(packet, offset)
        if offset + 10 > len(packet):
            return
        rtype, _, _, length = struct.unpack(">HHIH", packet[offset : offset + 10])
        offset += 10
        if offset + length > len(packet):
            return
        if rtype == T_SRV and length >= 6:
            yield name, struct.unpack(">H", packet[offset + 4 : offset + 6])[0]
        offset += length


def discover(service, timeout=2.5):
    """Send one PTR query and return every port answered, in arrival order."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # Own port 5353 and join the group when nothing else has them, so a
        # responder that multicasts its answer still reaches us. When another
        # mDNS daemon owns the port, the bind fails and the socket falls back
        # to an ephemeral one; the unicast-response bit covers that case.
        sock.bind(("", PORT))
        sock.setsockopt(
            socket.IPPROTO_IP,
            socket.IP_ADD_MEMBERSHIP,
            struct.pack("4sl", socket.inet_aton(GROUP), socket.INADDR_ANY),
        )
    except OSError:
        pass
    sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, 2)
    sock.settimeout(0.4)

    query = struct.pack(">HHHHHH", 0, 0, 1, 0, 0, 0)
    query += (
        b"".join(bytes([len(label)]) + label.encode() for label in service.split("."))
        + b"\x00"
    )
    query += struct.pack(">HH", T_PTR, 0x8001)  # class IN + unicast-response bit
    sock.sendto(query, (GROUP, PORT))

    ports, deadline = [], time.time() + timeout
    while time.time() < deadline:
        try:
            packet = sock.recvfrom(9000)[0]
        except TimeoutError:
            continue
        except OSError:
            break
        for name, port in srv_ports(packet):
            if name.startswith(service) and port not in ports:
                ports.append(port)
        if ports:
            deadline = min(deadline, time.time() + QUIET)
    sock.close()
    return ports


def main():
    ports = discover(PAIR if "--pair" in sys.argv[1:] else CONNECT)
    if not ports:
        sys.exit(1)
    print("\n".join(str(port) for port in ports))


if __name__ == "__main__":
    main()
