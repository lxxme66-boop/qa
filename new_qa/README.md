# 半导体QA生成系统 - vLLM HTTP版本

这是一个精简版的半导体QA生成系统，专门用于通过vLLM HTTP服务器方式运行。

## 目录结构

```
new_qa/
├── start_vllm_server.py      # vLLM服务器启动脚本
├── run_semiconductor_qa.py    # 主运行脚本
├── config_vllm_http.json      # vLLM HTTP配置文件
├── requirements.txt           # 依赖包列表
├── text_processor.py          # 文本处理器
├── semiconductor_qa_generator.py  # QA生成核心模块
├── enhanced_file_processor.py     # 增强文件处理器
├── argument_data.py           # 数据增强模块（可选）
├── clean_text_data.py         # 数据清洗模块
├── text_main_batch_inference_enhanced.py  # 批量推理模块
├── TextGeneration/            # 文本生成相关模块
│   ├── Datageneration.py
│   ├── prompts_conf.py
│   ├── reasoning_prompts.py
│   └── text_filter.py
├── TextQA/                    # 质量检查模块
│   ├── enhanced_quality_checker.py
│   ├── enhanced_quality_scorer.py
│   └── quality_assessment_templates.py
├── data/                      # 数据目录
│   ├── texts/                 # 输入文本文件目录
│   └── qa_results/            # 输出结果目录
└── logs/                      # 日志目录
```

## 安装步骤

1. **安装依赖**
```bash
cd new_qa
pip install -r requirements.txt
```

2. **准备模型**
确保你有可用的Qwen模型，例如：
- `/mnt/workspace/models/Qwen/QwQ-32B/`
- 或其他兼容的模型路径

## 运行方式

### 步骤1：启动vLLM服务器（终端1）

**基本启动：**
```bash
python start_vllm_server.py
```

**自定义参数启动：**
```bash
python start_vllm_server.py \
    --model-path /mnt/workspace/models/Qwen/QwQ-32B/ \
    --port 8000 \
    --gpu-memory-utilization 0.95 \
    --tensor-parallel-size 1 \
    --max-model-len 32768
```

启动后会看到类似输出：
```
============================================================
启动vLLM服务器
模型路径: /mnt/workspace/models/Qwen/QwQ-32B/
服务地址: http://0.0.0.0:8000
GPU内存利用率: 0.95
张量并行大小: 1
最大模型长度: 32768
============================================================
```

### 步骤2：运行文件处理（终端2）

在另一个终端中运行文件处理：

**使用配置文件：**
```bash
python run_semiconductor_qa.py \
    --input-dir data/texts \
    --output-dir data/qa_results \
    --config config_vllm_http.json
```

**通过环境变量配置：**
```bash
# 设置vLLM服务器地址
export VLLM_SERVER_URL=http://localhost:8000/v1

# 运行处理
python run_semiconductor_qa.py \
    --input-dir data/texts \
    --output-dir data/qa_results
```

## 配置说明

### config_vllm_http.json 主要配置项

- **api.vllm_server_url**: vLLM服务器地址，默认为 `http://localhost:8000/v1`
- **api.timeout**: API调用超时时间，默认120秒
- **models.qa_generator_model**: QA生成模型配置
- **processing.batch_size**: 批处理大小
- **quality_check.enabled**: 是否启用质量检查

### 参数说明

**start_vllm_server.py 参数：**
- `--model-path`: 模型路径
- `--port`: 服务端口（默认8000）
- `--gpu-memory-utilization`: GPU内存利用率（默认0.95）
- `--tensor-parallel-size`: 张量并行大小（默认2）
- `--max-model-len`: 最大模型长度（默认32768）

**run_semiconductor_qa.py 参数：**
- `--input-dir`: 输入文本文件目录
- `--output-dir`: 输出结果目录
- `--config`: 配置文件路径
- `--batch-size`: 批处理大小
- `--enable-full-steps`: 是否启用完整7步骤处理流程

## 使用示例

1. **准备输入数据**
   将要处理的txt文件放入 `data/texts/` 目录

2. **启动vLLM服务器**
   ```bash
   python start_vllm_server.py --model-path /path/to/your/model
   ```

3. **运行QA生成**
   ```bash
   python run_semiconductor_qa.py --input-dir data/texts --output-dir data/qa_results
   ```

4. **查看结果**
   结果将保存在 `data/qa_results/` 目录中

## 注意事项

1. **GPU内存**：根据你的GPU内存调整 `--gpu-memory-utilization` 参数
2. **并行设置**：如果有多个GPU，可以调整 `--tensor-parallel-size`
3. **模型路径**：确保模型路径正确，且模型文件完整
4. **端口冲突**：如果8000端口被占用，请更换其他端口

## 故障排除

1. **vLLM服务器启动失败**
   - 检查CUDA是否正确安装
   - 检查模型路径是否正确
   - 查看GPU内存是否足够

2. **连接vLLM服务器失败**
   - 确认vLLM服务器已启动
   - 检查端口是否正确
   - 检查防火墙设置

3. **处理速度慢**
   - 调整batch_size参数
   - 检查网络延迟
   - 考虑使用更多GPU资源

## 性能优化建议

1. 使用适当的批处理大小（batch_size）
2. 根据GPU内存调整模型加载参数
3. 对于大量文件，考虑分批处理
4. 监控GPU使用情况，避免OOM错误