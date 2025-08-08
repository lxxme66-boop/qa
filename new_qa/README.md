# vLLM QA System - 半导体显示技术智能问答系统

这是一个基于vLLM的半导体显示技术领域智能QA生成系统，采用分离式架构，支持高效的模型推理和问答生成。

## 系统特点

- **分离式架构**: vLLM服务器与QA处理分离，提高系统稳定性
- **高效推理**: 基于vLLM的高性能模型推理
- **专业领域**: 专注半导体显示技术领域的问答生成
- **模块化设计**: 可独立运行各个处理模块
- **质量保证**: 内置多层质量检查机制

## 目录结构

```
new_qa/
├── start_vllm_server.py          # vLLM服务器启动脚本
├── run_semiconductor_qa.py       # 主程序入口
├── semiconductor_qa_generator.py  # 核心QA生成器
├── text_processor.py             # 文本预处理器
├── enhanced_file_processor.py     # 增强文件处理器
├── argument_data.py               # 数据增强模块
├── text_main_batch_inference_enhanced.py  # 批量推理模块
├── clean_text_data.py             # 数据清洗模块
├── config_vllm_http.json          # vLLM HTTP配置
├── config.json                    # 主配置文件
├── requirements.txt               # 依赖包列表
├── TextGeneration/                # 文本生成模块
│   ├── Datageneration.py
│   ├── text_filter.py
│   ├── prompts_conf.py
│   └── reasoning_prompts.py
├── TextQA/                        # QA质量检查模块
│   ├── enhanced_quality_checker.py
│   ├── enhanced_quality_scorer.py
│   └── quality_assessment_templates.py
├── data/                          # 数据目录
│   ├── texts/                     # 输入文本文件
│   └── qa_results/                # QA生成结果
└── logs/                          # 日志目录
```

## 安装依赖

```bash
cd new_qa
pip install -r requirements.txt
```

## 使用方法

### 步骤1: 启动vLLM服务器

在第一个终端中启动vLLM服务器：

```bash
# 基本启动
python start_vllm_server.py

# 自定义参数启动
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

### 步骤2: 运行QA生成

在第二个终端中运行文件处理：

```bash
# 使用vLLM HTTP配置文件
python run_semiconductor_qa.py \
    --input-dir data/texts \
    --output-dir data/qa_results \
    --config config_vllm_http.json
```

或者通过环境变量配置：

```bash
# 设置vLLM服务器地址
export VLLM_SERVER_URL=http://localhost:8000/v1

# 运行处理
python run_semiconductor_qa.py \
    --input-dir data/texts \
    --output-dir data/qa_results
```

## 配置说明

### vLLM服务器配置 (config_vllm_http.json)

```json
{
  "api": {
    "use_vllm_http": true,
    "vllm_server_url": "http://localhost:8000/v1",
    "timeout": 120.0
  },
  "models": {
    "qa_generator_model": {
      "name": "qwen-vllm",
      "temperature": 0.7,
      "max_tokens": 2048
    }
  }
}
```

### 主要参数说明

- `--model-path`: 模型文件路径
- `--port`: vLLM服务器端口
- `--gpu-memory-utilization`: GPU内存利用率 (0.0-1.0)
- `--tensor-parallel-size`: 张量并行大小
- `--max-model-len`: 最大模型长度

## 数据格式

### 输入数据
将待处理的文本文件放入 `data/texts/` 目录，支持 `.txt` 格式。

### 输出数据
生成的QA数据将保存在 `data/qa_results/` 目录，包含：
- JSON格式的问答对
- 质量评估结果
- 处理日志

## 模块说明

### 核心模块

1. **start_vllm_server.py**: vLLM服务器启动器
2. **run_semiconductor_qa.py**: 主程序，协调各模块
3. **semiconductor_qa_generator.py**: 核心QA生成逻辑
4. **text_processor.py**: 文本预处理

### 辅助模块

1. **enhanced_file_processor.py**: 文件处理增强
2. **argument_data.py**: 数据增强（需要volcengine SDK）
3. **clean_text_data.py**: 数据清洗
4. **TextQA/**: 质量检查模块

## 环境要求

- Python 3.8+
- CUDA 11.0+ (用于GPU推理)
- 16GB+ GPU内存 (推荐)
- vLLM 0.2.0+

## 故障排除

### 常见问题

1. **vLLM启动失败**
   - 检查GPU内存是否足够
   - 确认模型路径是否正确
   - 检查CUDA版本兼容性

2. **连接超时**
   - 确认vLLM服务器已启动
   - 检查端口是否被占用
   - 调整timeout配置

3. **内存不足**
   - 降低gpu-memory-utilization参数
   - 减少max-model-len
   - 调整batch-size

## 许可证

本项目采用MIT许可证。

## 贡献

欢迎提交Issue和Pull Request。