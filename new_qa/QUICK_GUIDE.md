# vLLM QA系统 - 快速使用指南

## 🚀 一分钟快速启动

### 1. 安装依赖
```bash
cd new_qa
pip install -r requirements.txt
```

### 2. 启动系统
```bash
# 方式1: 使用快速启动脚本
./quick_start.sh

# 方式2: 手动启动
# 终端1: 启动vLLM服务器
python start_vllm_server.py --model-path /your/model/path

# 终端2: 运行QA生成
python run_semiconductor_qa.py --input-dir data/texts --output-dir data/qa_results --config config_vllm_http.json
```

## 📁 目录结构
```
new_qa/
├── start_vllm_server.py      # vLLM服务器启动器
├── run_semiconductor_qa.py   # 主程序
├── config_vllm_http.json     # vLLM配置
├── quick_start.sh            # 快速启动脚本
├── data/
│   ├── texts/                # 输入文本
│   └── qa_results/           # 输出结果
└── requirements.txt          # 依赖列表
```

## ⚙️ 核心配置

### 模型路径配置
```bash
# 设置环境变量
export MODEL_PATH=/mnt/workspace/models/Qwen/QwQ-32B/

# 或直接在命令中指定
python start_vllm_server.py --model-path /your/model/path
```

### 服务器配置
- 默认端口: 8000
- GPU内存利用率: 0.95
- 张量并行大小: 1

## 📝 使用流程

1. **准备数据**: 将文本文件放入 `data/texts/`
2. **启动服务**: 运行vLLM服务器
3. **生成QA**: 运行QA生成程序
4. **查看结果**: 检查 `data/qa_results/` 中的输出

## 🔧 常见问题

**Q: vLLM启动失败？**
A: 检查GPU内存、模型路径、CUDA版本

**Q: 连接超时？**
A: 确认vLLM服务器已启动，检查端口占用

**Q: 内存不足？**
A: 降低gpu-memory-utilization参数

## 📞 获取帮助

查看详细文档: `README.md`
运行帮助: `python start_vllm_server.py --help`