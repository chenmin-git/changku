import { chromium } from 'playwright';
import fs from 'node:fs/promises';
import path from 'node:path';

const root = path.resolve(process.cwd(), '..');
const docsDir = path.join(root, 'docs', 'demo-screenshots');
const publicDir = path.join(process.cwd(), 'public', 'screenshots');
const baseUrl = process.env.DEMO_URL || 'http://localhost:15174';
const apiUrl = process.env.API_URL || 'http://localhost:18080';

const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const shots = [];
let index = 1;

async function ensureDirs() {
  await fs.rm(docsDir, { recursive: true, force: true });
  await fs.rm(publicDir, { recursive: true, force: true });
  await fs.mkdir(docsDir, { recursive: true });
  await fs.mkdir(publicDir, { recursive: true });
}

async function shot(page, title, description) {
  await page.waitForLoadState('networkidle').catch(() => {});
  await delay(450);
  const file = `${String(index).padStart(2, '0')}-${title.replace(/[\\/:*?"<>|\s]+/g, '-')}.png`;
  const docPath = path.join(docsDir, file);
  const publicPath = path.join(publicDir, file);
  await page.screenshot({ path: docPath, fullPage: false });
  await fs.copyFile(docPath, publicPath);
  shots.push({ file, title, description });
  index += 1;
}

async function login(page) {
  await page.goto(`${baseUrl}/login`, { waitUntil: 'networkidle' });
  await page.evaluate(() => { document.body.style.zoom = '110%'; });
  await shot(page, '登录页-系统入口', '登录页采用中文业务文案，展示仓库管理流程入口。');
  await page.getByPlaceholder('请输入账号').fill('admin');
  await shot(page, '登录页-输入账号', '输入管理员账号，准备进入系统。');
  await page.getByPlaceholder('请输入密码').fill('123456');
  await shot(page, '登录页-输入密码', '填写演示密码后进入管理端。');
  await page.getByRole('button', { name: /进入系统/ }).click();
  await page.waitForURL(/dashboard/, { timeout: 15000 });
  await page.evaluate(() => { document.body.style.zoom = '110%'; });
}

async function goto(page, route) {
  await page.goto(`${baseUrl}${route}`, { waitUntil: 'networkidle' });
  await page.evaluate(() => { document.body.style.zoom = '110%'; });
}

async function clickIfVisible(page, text) {
  const target = page.getByText(text, { exact: false }).first();
  if (await target.count()) {
    await target.click().catch(() => {});
    await delay(500);
  }
}

async function captureAi(page) {
  await goto(page, '/assistant');
  await shot(page, 'AI助手-初始界面', '智能库存助手展示待办概览、分析工具箱和高风险货品。');
  await shot(page, 'AI助手-工具箱', '左侧工具箱提供补货、预警、趋势、盘点、仓库和待办分析入口。');
  await page.getByText('生成补货计划', { exact: true }).first().click();
  await delay(2500);
  await shot(page, 'AI助手-补货计划生成中', '点击补货计划后，系统读取库存上下文并流式生成回答。');
  await delay(4500);
  await shot(page, 'AI助手-补货计划结果', 'AI 输出补货优先级和业务处理建议。');
  await page.getByText('分析高风险库存预警', { exact: false }).first().click();
  await delay(4500);
  await shot(page, 'AI助手-高风险预警分析', 'AI 根据待处理预警解释风险原因和处理顺序。');
  await page.getByText('总结近 7 天入出库趋势', { exact: false }).first().click();
  await delay(4500);
  await shot(page, 'AI助手-七天趋势解读', 'AI 解读近 7 天入库、出库变化，辅助仓储决策。');
  await page.getByText('生成盘点任务清单', { exact: false }).first().click();
  await delay(4500);
  await shot(page, 'AI助手-盘点任务清单', 'AI 将预警、低库存和出库情况转化为盘点任务。');
  await page.getByPlaceholder(/输入库存相关问题/).fill('按仓库维度给出补货和调拨建议');
  await shot(page, 'AI助手-自然语言输入', '支持自然语言提问，不局限于固定按钮。');
  await page.getByRole('button', { name: '发送' }).click();
  await delay(4500);
  await shot(page, 'AI助手-自然语言回答', 'AI 结合仓库维度返回补货与调拨建议。');
}

async function captureBusiness(page) {
  await goto(page, '/dashboard');
  await shot(page, '工作台-全局统计', '工作台展示货品、预警、入库和用户等核心指标。');
  await shot(page, '工作台-七天趋势', '近 7 天入出库趋势用于观察库存流动变化。');
  await shot(page, '工作台-快捷待办', '待处理事项快捷入口可直接跳转到对应业务模块。');
  await shot(page, '工作台-风险排行', '高风险库存 TOP5 按库存缺口排序，便于优先处理。');
  await shot(page, '工作台-最近操作', '操作日志保留业务处理痕迹，适合答辩展示闭环。');

  await goto(page, '/goods');
  await shot(page, '货品档案-列表分页', '货品档案支持分页、筛选、图片和库存信息展示。');
  await clickIfVisible(page, '查询');
  await shot(page, '货品档案-查询筛选', '列表页提供关键词、状态和分类筛选。');
  await page.getByRole('button', { name: /导出Excel/ }).click();
  await delay(500);
  await shot(page, '货品档案-导出Excel', '导出按钮可将当前页数据导出为 Excel 可打开的文件。');
  await page.locator('.icon-actions button').first().click();
  await delay(700);
  await shot(page, '货品档案-详情弹窗', '详情弹窗字段已中文化，分类和仓库显示为业务名称。');
  await page.keyboard.press('Escape');
  await delay(300);
  await page.getByRole('button', { name: '新增' }).click();
  await delay(700);
  await shot(page, '货品档案-新增表单', '新增表单中分类、仓库、状态均为下拉选择。');
  await page.keyboard.press('Escape');

  await goto(page, '/inbounds');
  await shot(page, '入库管理-列表', '入库管理展示待审核、已入库和驳回状态。');
  await shot(page, '入库管理-业务操作', '待审核单据可执行审核入库或驳回操作。');
  await goto(page, '/outbounds');
  await shot(page, '出库管理-列表', '出库管理用于客户出库单处理和出库确认。');
  await goto(page, '/checks');
  await shot(page, '库存盘点-列表', '盘点模块用于账面数量、实盘数量和差异处理。');
  await goto(page, '/alerts');
  await shot(page, '库存预警-列表', '库存预警模块展示预警等级、当前库存和处理建议。');
  await goto(page, '/warehouses');
  await shot(page, '仓库管理-基础资料', '仓库管理维护仓库编码、位置、负责人和容量。');
  await goto(page, '/categories');
  await shot(page, '货品分类-基础资料', '货品分类用于组织不同业务类型的库存物资。');
  await goto(page, '/suppliers');
  await shot(page, '供应商管理-列表', '供应商管理维护联系人、等级、状态和地址。');
  await goto(page, '/customers');
  await shot(page, '客户管理-列表', '客户管理记录客户联系人和业务等级。');
  await goto(page, '/notices');
  await shot(page, '公告管理-列表', '公告管理用于发布系统通知和仓储提示。');
  await goto(page, '/logs');
  await shot(page, '操作日志-列表', '操作日志记录用户对业务数据的增删改和流程处理。');
  await goto(page, '/profile');
  await shot(page, '个人中心-账户信息', '个人中心支持查看当前用户信息和修改密码。');
}

async function main() {
  await ensureDirs();
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1728, height: 972 }, deviceScaleFactor: 1 });
  page.setDefaultTimeout(15000);
  await login(page);
  await captureBusiness(page);
  await captureAi(page);
  await browser.close();
  await fs.writeFile(path.join(process.cwd(), 'src', 'full-demo-scenes.json'), JSON.stringify(shots, null, 2), 'utf8');
  await fs.writeFile(path.join(docsDir, 'shots.json'), JSON.stringify(shots, null, 2), 'utf8');
  console.log(`Captured ${shots.length} screenshots`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
