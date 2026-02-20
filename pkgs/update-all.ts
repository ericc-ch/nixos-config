#!/usr/bin/env -S deno run --allow-read --allow-run

const EXCLUDED_DIRS = ["lib", "node_modules"];

const moduleDir = import.meta.dirname ?? ".";

const entries = [];
for await (const entry of Deno.readDir(moduleDir)) {
  entries.push(entry);
}

const updateScripts = await Promise.all(
  entries
    .filter((entry) => entry.isDirectory && !EXCLUDED_DIRS.includes(entry.name))
    .map(async (entry) => {
      const updatePath = `${moduleDir}/${entry.name}/update.ts`;
      try {
        await Deno.stat(updatePath);
        return updatePath;
      } catch {
        return null;
      }
    }),
).then((results) => results.filter((path): path is string => path !== null));

await Promise.all(
  updateScripts.sort().map(async (script) => {
    const command = new Deno.Command("deno", {
      args: ["run", "--allow-net", "--allow-write", script],
      stdout: "inherit",
      stderr: "inherit",
    });
    await command.output();
  }),
);
