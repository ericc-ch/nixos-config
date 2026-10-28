#!/data/data/com.termux/files/usr/bin/python3
"""Print this phone's wireless-debugging port, discovered over mDNS.

  adb-port.py          the _adb-tls-connect port, the one `adb connect` wants
  adb-port.py --pair   the _adb-tls-pairing port, only advertised while the
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


def read_name(packet, offset):
    """Return (dotted name, offset just past it), following compression pointers."""
    labels, resume = [], None
    while offset < len(packet) and packet[offset]:
        length = packet[offset]
        if length & 0xC0 == 0xC0:  # pointer: jump, but remember where to resume
            if resume is None:
                resume = offset + 2
            offset = struct.unpack(">H", packet[offset : offset + 2])[0] & 0x3FFF
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
    """Send one PTR query and return the first port answered, or None."""
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)
    try:
        sock.bind(("", PORT))
    except OSError:
        pass  # 5353 is taken; the unicast-response bit below still gets an answer
    try:
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

    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            packet = sock.recvfrom(9000)[0]
        except TimeoutError:
            continue
        except OSError:
            break
        for name, port in srv_ports(packet):
            if name.startswith(service):
                sock.close()
                return port
    sock.close()
    return None


def main():
    port = discover(PAIR if "--pair" in sys.argv[1:] else CONNECT)
    if port is None:
        sys.exit(1)
    print(port)


if __name__ == "__main__":
    main()
