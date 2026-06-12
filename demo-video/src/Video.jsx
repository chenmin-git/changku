import React from 'react';
import {
  AbsoluteFill,
  Img,
  interpolate,
  staticFile,
  useCurrentFrame,
} from 'remotion';
import scenes from './full-demo-scenes.json';

export const SCENE_DURATION = 100;

const selectedSceneNumbers = [
  1,
  26, 29, 30, 31,
  4, 7,
  9, 13,
  14, 16, 17, 18,
  19, 21, 24,
];

const selectedScenes = selectedSceneNumbers.map((sceneNumber) => ({
  ...scenes[sceneNumber - 1],
  sceneNumber,
}));

export const TOTAL_DURATION_IN_FRAMES = selectedScenes.length * SCENE_DURATION;

const sceneGroups = [
  { from: 1, to: 1, label: '系统登录' },
  { from: 4, to: 8, label: '工作台统计' },
  { from: 9, to: 13, label: '货品档案' },
  { from: 14, to: 25, label: '业务闭环' },
  { from: 26, to: 34, label: '智能辅助' },
];

const getGroup = (sceneNo) => {
  return sceneGroups.find((item) => sceneNo >= item.from && sceneNo <= item.to)?.label || '功能演示';
};

export const DemoVideo = () => {
  const frame = useCurrentFrame();
  const sceneIndex = Math.min(Math.floor(frame / SCENE_DURATION), selectedScenes.length - 1);
  const scene = selectedScenes[sceneIndex];
  const localFrame = frame - sceneIndex * SCENE_DURATION;

  const imageOpacity = interpolate(localFrame, [0, 8], [0.72, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const introOpacity = sceneIndex === 0
    ? interpolate(localFrame, [0, 12, 84, 100], [0, 1, 1, 0], {
        extrapolateLeft: 'clamp',
        extrapolateRight: 'clamp',
      })
    : 0;

  return (
    <AbsoluteFill style={styles.root}>
      <div style={styles.topBar}>
        <div style={styles.brand}>智能仓库管理系统</div>
        <div style={styles.title}>{scene.title.replace(/-/g, ' / ')}</div>
        <div style={styles.sceneBadge}>
          {getGroup(scene.sceneNumber)} · {String(sceneIndex + 1).padStart(2, '0')}/{selectedScenes.length}
        </div>
      </div>

      <div style={styles.frame}>
        <Img
          src={staticFile(`screenshots/${scene.file}`)}
          style={{
            ...styles.image,
            opacity: imageOpacity,
          }}
        />
      </div>

      {sceneIndex === 0 ? (
        <div style={{ ...styles.introPanel, opacity: introOpacity }}>
          <div style={styles.introKicker}>毕业设计演示</div>
          <div style={styles.introTitle}>仓库业务管理 + AI 库存分析</div>
          <div style={styles.introGrid}>
            <div style={styles.introItem}>
              <span style={styles.introLabel}>功能</span>
              <span>出入库、盘点、预警、档案、日志</span>
            </div>
            <div style={styles.introItem}>
              <span style={styles.introLabel}>框架</span>
              <span>Vue3 / Element Plus / Spring Boot / MySQL</span>
            </div>
            <div style={styles.introItem}>
              <span style={styles.introLabel}>创新</span>
              <span>AI 读取实时库存上下文，生成补货和风险建议</span>
            </div>
          </div>
        </div>
      ) : null}

      <div style={styles.captionBox}>
        <div style={styles.captionText}>{scene.description}</div>
      </div>

      <div style={styles.progressOuter}>
        <div style={{ ...styles.progressInner, width: `${(frame / TOTAL_DURATION_IN_FRAMES) * 100}%` }} />
      </div>
    </AbsoluteFill>
  );
};

const styles = {
  root: {
    background: '#0f172a',
    fontFamily: 'Microsoft YaHei, SimHei, Arial, sans-serif',
    color: '#f8fafc',
    overflow: 'hidden',
  },
  topBar: {
    position: 'absolute',
    left: 120,
    right: 120,
    top: 0,
    height: 64,
    display: 'flex',
    alignItems: 'center',
    gap: 22,
  },
  brand: {
    flexShrink: 0,
    fontSize: 18,
    fontWeight: 600,
    color: '#93c5fd',
  },
  title: {
    minWidth: 0,
    flex: 1,
    overflow: 'hidden',
    textOverflow: 'ellipsis',
    whiteSpace: 'nowrap',
    fontSize: 25,
    fontWeight: 700,
  },
  sceneBadge: {
    flexShrink: 0,
    fontSize: 16,
    color: '#cbd5e1',
  },
  frame: {
    position: 'absolute',
    left: 120,
    top: 64,
    width: 1680,
    height: 945,
    borderRadius: 6,
    overflow: 'hidden',
    background: '#e5e7eb',
    boxShadow: '0 18px 48px rgba(0,0,0,.32)',
  },
  image: {
    width: '100%',
    height: '100%',
    objectFit: 'contain',
  },
  introPanel: {
    position: 'absolute',
    left: 220,
    right: 220,
    top: 190,
    padding: '34px 42px',
    borderRadius: 8,
    background: 'rgba(15, 23, 42, .88)',
    boxShadow: '0 24px 68px rgba(15, 23, 42, .42)',
    border: '1px solid rgba(148, 163, 184, .34)',
  },
  introKicker: {
    fontSize: 22,
    color: '#93c5fd',
    fontWeight: 700,
    marginBottom: 12,
  },
  introTitle: {
    fontSize: 44,
    lineHeight: 1.18,
    fontWeight: 800,
    marginBottom: 28,
  },
  introGrid: {
    display: 'grid',
    gridTemplateColumns: '1fr',
    gap: 14,
  },
  introItem: {
    display: 'grid',
    gridTemplateColumns: '84px 1fr',
    alignItems: 'center',
    gap: 18,
    fontSize: 25,
    lineHeight: 1.35,
    color: '#f8fafc',
  },
  introLabel: {
    display: 'inline-flex',
    justifyContent: 'center',
    padding: '6px 0',
    borderRadius: 6,
    background: '#2563eb',
    fontSize: 20,
    fontWeight: 700,
  },
  captionBox: {
    position: 'absolute',
    left: 120,
    right: 120,
    bottom: 16,
    height: 46,
    display: 'flex',
    alignItems: 'center',
  },
  captionText: {
    width: '100%',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
    whiteSpace: 'nowrap',
    textAlign: 'center',
    fontSize: 22,
    lineHeight: 1.3,
    fontWeight: 600,
    color: '#e2e8f0',
  },
  progressOuter: {
    position: 'absolute',
    left: 120,
    right: 120,
    bottom: 8,
    height: 3,
    background: 'rgba(255,255,255,.18)',
    overflow: 'hidden',
  },
  progressInner: {
    height: '100%',
    background: '#22c55e',
  },
};
