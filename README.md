# 智能仓库管理系统

一个用于毕业设计演示的前后端分离仓库管理系统，包含登录鉴权、角色菜单、仓库基础资料、出入库、盘点、库存预警、ECharts 工作台、图片上传和智能库存助手。

## 项目亮点

- 前端：`Vue3`、`Element Plus`、`Pinia`、`ECharts`，适合管理端高频表格和看板场景。
- 后端：`Spring Boot 3`、`MyBatis-Plus`、`MySQL`，提供登录鉴权、通用 CRUD、上传和 AI 接口。
- 业务：覆盖货品档案、仓库、供应商、客户、入库、出库、盘点、库存预警、公告和操作日志。
- 创新点：AI 助手会读取库存、预警、趋势和待办上下文，生成补货计划、风险解释和盘点建议。

## 演示视频

- 视频文件：[docs/smart-warehouse-ai-demo.mp4](docs/smart-warehouse-ai-demo.mp4)
- 最新版节奏：开头先介绍功能、技术框架和 AI 创新点，AI 功能提前展示，后续业务模块快速演示。

## 启动方式

1. 导入完整数据库文件：`cmd /c "mysql -uroot -proot < database\smart_warehouse.sql"`。
2. 后端：进入 `backend`，执行 `./mvnw spring-boot:run`。
3. 前端：进入 `frontend`，执行 `npm install` 后运行 `npm run dev`，默认访问 `http://localhost:15174`。

演示账号：

- 管理员：`admin / 123456`
- 仓管员：`keeper / 123456`

## AI 配置

智能助手通过后端读取环境变量 `SPARK_API_KEY` 调用系统默认 AI 服务。未配置时会自动使用本地库存分析结果，前端不会接触密钥。

```bash
SPARK_API_KEY=your_api_key_here
```

当前 AI 兼容讯飞星火 OpenAI 风格接口，默认地址配置在 `backend/src/main/resources/application.yml` 的 `app.spark.base-url` 中。
