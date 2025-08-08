async def main():
    """主函数 - 调用新的流水线"""
    
    # 加载配置
    with open('config.json', 'r') as f:
        config = json.load(f)
    
    # 运行新的流水线
    results = await run_complete_pipeline(
        config=config,
        input_dir="data/texts",
        output_dir="data/qa_results",
        model_name="qwq_32", 
        batch_size=2,
        gpu_devices="0,1",
        quality_threshold=0.7  # 新参数：质量阈值
    )
    
    print(f"流水线完成，生成了 {len(results)} 个最终QA对")

if __name__ == "__main__":
    asyncio.run(main())
