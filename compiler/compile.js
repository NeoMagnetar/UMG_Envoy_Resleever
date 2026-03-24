const fs = require("fs");
const path = require("path");

function parseArgs(argv) {
 const out = {};
 for (let i = 2; i < argv.length; i++) {
 const a = argv[i];
 if (a === "--input") out.input = argv[++i];
 else if (a === "--output") out.output = argv[++i];
 }
 return out;
}

function readJson(filePath) {
 return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function writeJson(filePath, data) {
 fs.mkdirSync(path.dirname(filePath), { recursive: true });
 fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
}

function fail(message, extra = {}) {
 console.error("COMPILE_ERROR:", message);
 if (Object.keys(extra).length) {
 console.error(JSON.stringify(extra, null, 2));
 }
 process.exit(1);
}

function ensureString(value, field) {
 if (typeof value !== "string" || !value.trim()) {
 fail(`Invalid or missing string field: ${field}`);
 }
}

function ensureArray(value, field) {
 if (!Array.isArray(value)) {
 fail(`Invalid or missing array field: ${field}`);
 }
}

function uniqueStrings(items) {
 return [...new Set(items.filter(v => typeof v === "string" && v.trim()))];
}

function validateSleeve(input) {
 ensureString(input.id, "id");
 ensureArray(input.stacks, "stacks");

 const normalizedStacks = uniqueStrings(input.stacks);
 if (!normalizedStacks.length) {
 fail("Sleeve must contain at least one stack");
 }

 return {
 id: input.id,
 version: typeof input.version === "string" ? input.version : "1.0.0",
 mode: typeof input.mode === "string" ? input.mode : "operator",
 bpMode: typeof input.bpMode === "string" ? input.bpMode : "NL",
 stacks: normalizedStacks,
 posture: typeof input.posture === "object" && input.posture ? input.posture : {},
 tools: typeof input.tools === "object" && input.tools ? input.tools : {},
 capabilities: typeof input.capabilities === "object" && input.capabilities ? input.capabilities : {},
 notes: typeof input.notes === "string" ? input.notes : ""
 };
}

function compileSleeveToRuntimeSpec(sleeve) {
 return {
 specType: "runtime-spec",
 sourceType: "sleeve",
 sourceId: sleeve.id,
 version: sleeve.version,
 compiledAt: new Date().toISOString(),

 activeSleeve: {
 id: sleeve.id,
 version: sleeve.version,
 mode: sleeve.mode,
 bpMode: sleeve.bpMode
 },

 stacks: sleeve.stacks,

 runtime: {
 mode: sleeve.mode,
 bpMode: sleeve.bpMode,
 status: "compiled",
 permissive: true
 },

 posture: {
 localFirst: true,
 repoOperator: true,
 browserEnabled: true,
 execEnabled: true,
 lowGovernance: true,
 askBeforeExternalOnly: true,
 ...sleeve.posture
 },

 tools: {
 exec: "broad",
 browser: "broad",
 web: "broad",
 fileOps: "broad",
 github: "broad",
 ...sleeve.tools
 },

 capabilities: {
 codeEdit: true,
 fileReadWrite: true,
 repoWork: true,
 browserAutomation: true,
 webResearch: true,
 runtimeActivation: true,
 ...sleeve.capabilities
 },

 compilerMeta: {
 strategy: "minimal-pass-through-normalizer",
 warnings: [],
 futureUpgradePath: [
 "MOLT validation",
 "NeoStack expansion",
 "NeoBlock resolution",
 "conflict detection",
 "bundle/merge logic"
 ]
 },

 notes: sleeve.notes
 };
}

function writeCompileReport(outputPath, ok, details) {
 const reportPath = path.join(path.dirname(outputPath), "last-compile-report.json");
 writeJson(reportPath, {
 status: ok ? "success" : "failed",
 timestamp: new Date().toISOString(),
 details
 });
}

function main() {
 const args = parseArgs(process.argv);

 if (!args.input) fail("Missing --input");
 if (!args.output) fail("Missing --output");

 const inputPath = path.resolve(args.input);
 const outputPath = path.resolve(args.output);

 if (!fs.existsSync(inputPath)) {
 fail("Input sleeve file not found", { inputPath });
 }

 let sleeve;
 try {
 sleeve = readJson(inputPath);
 } catch (err) {
 fail("Failed to parse input JSON", { inputPath, error: err.message });
 }

 const validated = validateSleeve(sleeve);
 const runtimeSpec = compileSleeveToRuntimeSpec(validated);

 try {
 writeJson(outputPath, runtimeSpec);
 writeCompileReport(outputPath, true, {
 inputPath,
 outputPath,
 sourceId: validated.id,
 stacks: validated.stacks
 });
 } catch (err) {
 fail("Failed to write output", { outputPath, error: err.message });
 }

 console.log("COMPILE_OK");
 console.log(JSON.stringify({
 sourceId: validated.id,
 outputPath,
 stacks: validated.stacks
 }, null, 2));
}

main();
