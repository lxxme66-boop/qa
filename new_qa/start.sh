#!/bin/bash

# 半导体QA生成系统启动脚本

echo "=================================================="
echo "半导体QA生成系统 - vLLM HTTP版本"
echo "=================================================="

# 检查参数
if [ "$1" == "server" ]; then
    echo "启动vLLM服务器..."
    echo "使用默认参数，如需自定义请直接运行: python start_vllm_server.py --help"
    python start_vllm_server.py
elif [ "$1" == "process" ]; then
    echo "启动QA处理..."
    echo "请确保vLLM服务器已在另一个终端中运行"
    python run_semiconductor_qa.py \
        --input-dir data/texts \
        --output-dir data/qa_results \
        --config config_vllm_http.json
elif [ "$1" == "help" ] || [ -z "$1" ]; then
    echo ""
    echo "使用方法:"
    echo "  ./start.sh server   - 启动vLLM服务器"
    echo "  ./start.sh process  - 运行QA处理"
    echo "  ./start.sh help     - 显示此帮助信息"
    echo ""
    echo "完整流程:"
    echo "  1. 在终端1运行: ./start.sh server"
    echo "  2. 在终端2运行: ./start.sh process"
    echo ""
else
    echo "未知命令: $1"
    echo "运行 ./start.sh help 查看使用方法"
fi