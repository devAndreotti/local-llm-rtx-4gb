# local-llm-rtx-4gb

Pre-tuned Ollama Modelfiles and comprehensive 2026 benchmarks for running local AI models on entry-level laptop GPUs (NVIDIA RTX 2050 / RTX 3050 / 4 GB VRAM).

Drop-in configs that unlock 100% CUDA offload, sub-second latency, and native Tool Calling / MCP support without CPU bottlenecks.

> **Hardware Testbed:** Windows 11 Pro · Intel Core i5-12450H (8C/12T) · 16 GB DDR4 · NVIDIA GeForce RTX 2050 (4 GB GDDR6) · Ollama 0.33.x · Promptfoo 0.122.x

---

## 🚀 2026 Benchmark: Results at a Glance

Evaluated across **Coding (TypeScript Memoization)**, **Strict JSON Extraction (Zero Markdown)**, **Complex Logic (River Crossing Riddle)**, and **MCP Tool Calling**.

| Model | Size (Q4) | Execution Mode | Speed (tok/s) | Strict JSON | Tool Calling / MCP | Logic / Reasoning | Best For |
|---|---|---|---|---|---|---|---|
| **Qwen 2.5 Coder 3B** | 1.9 GB | **100% GPU** | **~47 tok/s** | ✅ Pass | ✅ Native OpenAI ToolCalls | ✅ Pass | **Daily Driver Code & Scripts** |
| **Qwen 2.5 3B (Chat)** | 1.9 GB | **100% GPU** | **~45 tok/s** | ✅ Pass | ✅ Native OpenAI ToolCalls | ✅ Pass | **General Chat, Agents & MCP** |
| **DeepSeek R1 1.5B** | 1.1 GB | **100% GPU** | **~80 tok/s** | ⚠️ Includes `<think>` | ❌ No native tool-calling | ✅ Full CoT Thinking | **Math, Logic & Quick Brainstorm** |
| **DeepSeek R1 7B** | 4.7 GB | Híbrido (58% CPU / 42% GPU) | **~3-5 tok/s** | ✅ Pass | ❌ Slow on 4GB VRAM | 🌟 State-of-the-Art CoT | Hard logic only (slow on laptops) |
| **Gemma 4 E2B QAT** | 1.6 GB | **100% GPU** | **~49 tok/s** | ✅ Pass | ❌ Emits markdown | ⚠️ Basic | Fast text summary (128K ctx) |
| **Gemma 4 E4B QAT** | 3.0 GB | **100% GPU** | **~29 tok/s** | ✅ Pass | ❌ Emits markdown | ⚠️ Basic | Legacy assistant |
| **Gemma 2 9B q3_K_S** | 4.3 GB | Híbrido (70% GPU / 30% CPU) | **~7.7 tok/s** | ⚠️ High latency | ❌ Redundant | ⚠️ Slower than Qwen 3B | Deprecated (outclassed by 3B) |

---

## 🔍 Key Findings & Architectural Insights

### 1. The 3B Sweet Spot (The Death of 7B-9B on 4GB GPUs)
Trying to run 7B or 9B models on a 4 GB GPU forces Ollama to split layers between VRAM and system RAM. The memory bandwidth drop from GDDR6 (~112 GB/s) to system DDR4 (~25 GB/s) kills performance:
- **DeepSeek R1 7B** took **429 seconds** to generate complex output.
- **Qwen 2.5 Coder 3B** fits 100% in VRAM (leaving ~2 GB for Windows/system apps) and generated the same algorithm in **under 2 seconds at 47 tokens/sec**.
- In practical coding and JSON benchmarks, **Qwen 2.5 3B matched or exceeded Gemma 2 9B quality** at 6x the speed.

### 2. Native MCP & Tool Calling Support
Most small local models fail when asked to call external functions in strict schemas.
- **Qwen 2.5 (3B and Coder 3B)** natively support the OpenAI tool format (`tool_calls` object with function name and arguments). They integrate seamlessly into AI agent frameworks and MCP servers.
- **DeepSeek R1** models output chain-of-thought (`<think>...</think>`) tags, making them ideal for logic verification or reasoning pipelines, but unsuitable as direct tool dispatchers.

### 3. Strict JSON (Zero Markdown)
When prompted with `Retorne APENAS um JSON valido sem markdown`:
- `Qwen 2.5` passed with pure parseable JSON without code fences.
- `DeepSeek R1` wrapped JSON inside markdown code blocks alongside its reasoning traces.

---

## 🛠️ Modelfiles Included

Pre-tuned Modelfiles located in `/modelfiles`:
- `qwen-code-3b.Modelfile`: Deterministic coding assistant (`temp 0.2`, `num_gpu 99`, `num_ctx 8192`).
- `qwen-chat-3b.Modelfile`: General purpose chat and JSON extractor (`num_gpu 99`, `num_ctx 8192`).
- `r1-fast-1.5b.Modelfile`: High-speed reasoning with chain-of-thought (`num_gpu 99`, `num_ctx 8192`).
- `gemma-*.Modelfile`: Legacy Gemma configurations.

---

## 🧪 Reproducing the Benchmark

The test suite uses [promptfoo](https://github.com/promptfoo/promptfoo):

```bash
cd benchmark
# Run the full VRAM comparison
pf eval -c promptfooconfig-fast.yaml --max-concurrency 1

# Open interactive dashboard
pf view
```

---

## 💡 Recommended Setup for 4GB VRAM Laptops

1. **Coding & Terminal Automation:** Use `qwen2.5-coder:3b` as your primary local assistant.
2. **AI Agents & MCP:** Use `qwen2.5:3b` for function calling and structured decision workflows.
3. **Logic Verification:** Use `deepseek-r1:1.5b` as a second-pass validator or reasoning engine.
