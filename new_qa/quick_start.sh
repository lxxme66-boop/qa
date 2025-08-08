#!/bin/bash

# vLLM QA System Quick Start Script
# 快速启动vLLM半导体QA系统

echo "=========================================="
echo "vLLM QA System Quick Start"
echo "vLLM半导体QA系统快速启动"
echo "=========================================="

# 检查Python环境
if ! command -v python &> /dev/null; then
    echo "错误: Python未安装或未在PATH中"
    exit 1
fi

echo "Python版本: $(python --version)"

# 检查是否安装了依赖
echo "检查依赖..."
if ! python -c "import vllm" 2>/dev/null; then
    echo "警告: vLLM未安装，请运行: pip install -r requirements.txt"
fi

# 设置默认参数
MODEL_PATH=${MODEL_PATH:-"/mnt/workspace/models/Qwen/QwQ-32B/"}
PORT=${PORT:-8000}
GPU_MEMORY=${GPU_MEMORY:-0.95}
TENSOR_PARALLEL=${TENSOR_PARALLEL:-1}
MAX_MODEL_LEN=${MAX_MODEL_LEN:-32768}

# 检查模型路径
if [ ! -d "$MODEL_PATH" ]; then
    echo "警告: 模型路径不存在: $MODEL_PATH"
    echo "请设置正确的模型路径，例如:"
    echo "export MODEL_PATH=/path/to/your/model"
    echo ""
fi

echo "配置参数:"
echo "  模型路径: $MODEL_PATH"
echo "  端口: $PORT"
echo "  GPU内存利用率: $GPU_MEMORY"
echo "  张量并行大小: $TENSOR_PARALLEL"
echo "  最大模型长度: $MAX_MODEL_LEN"
echo ""

# 提供启动选项
echo "请选择启动方式:"
echo "1. 启动vLLM服务器"
echo "2. 运行QA生成 (需要vLLM服务器已启动)"
echo "3. 完整流程 (分两个终端)"
echo "4. 退出"

read -p "请输入选择 (1-4): " choice

case $choice in
    1)
        echo "启动vLLM服务器..."
        python start_vllm_server.py \
            --model-path "$MODEL_PATH" \
            --port "$PORT" \
            --gpu-memory-utilization "$GPU_MEMORY" \
            --tensor-parallel-size "$TENSOR_PARALLEL" \
            --max-model-len "$MAX_MODEL_LEN"
        ;;
    2)
        echo "运行QA生成..."
        echo "请确保vLLM服务器已在端口 $PORT 启动"
        read -p "继续? (y/N): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            python run_semiconductor_qa.py \
                --input-dir data/texts \
                --output-dir data/qa_results \
                --config config_vllm_http.json
        fi
        ;;
    3)
        echo "完整流程需要两个终端:"
        echo ""
        echo "终端1 - 启动vLLM服务器:"
        echo "cd $(pwd)"
        echo "python start_vllm_server.py --model-path $MODEL_PATH --port $PORT --gpu-memory-utilization $GPU_MEMORY --tensor-parallel-size $TENSOR_PARALLEL --max-model-len $MAX_MODEL_LEN"
        echo ""
        echo "终端2 - 运行QA生成:"
        echo "cd $(pwd)"
        echo "python run_semiconductor_qa.py --input-dir data/texts --output-dir data/qa_results --config config_vllm_http.json"
        echo ""
        echo "请在两个不同的终端中分别运行上述命令"
        ;;
    4)
        echo "退出"
        exit 0
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac