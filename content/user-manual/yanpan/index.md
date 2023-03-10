---
title: 事件分析研判
linkTitle: 分析研判
description: 安全事件调查分析，快速确定事件真伪.
date: 2022-12-29
publishdate: 2022-12-29
categories: [usage,fundamentals]
keywords: [usage,zonglan,event]
menu:
  docs:
    parent: user-manual
    weight: 40
toc: true

aliases: [/content/usage/yanpan/]
isCJKLanguage: true
---

## **研判**
研判页面是通过提供丰富的上下文信息，如告警信息、设备画像、安全事件时序分布、动作特征图谱、证据等模块，来辅助用户深入的了解安全事件，快速确定事件真伪。

## **基本信息**
基本信息除了提供安全事件的告警信息之外，还提供额外操作。
### **事件处置**
1. 点击切换操作标签。
1. 在输入框输入操作备注。
1. 点击“事件处置”。

![](/img/usage/Aspose.Words.4325b89e-3d42-4255-924b-c68f9f0e7d81.045.png)

### **事件报告**
事件报告提供对于该事件的处置分析报告压缩包，压缩包中有四部分内容：事件处置报告、离散告警详细数据、动作特征数据、证据数据。

1. 点击“生成报告”，弹出报告弹窗。
1. 预览报告内容，在人工建议中输入内容。
1. 点击“报告下载”下载，下载后解压缩。

![](/img/usage/Aspose.Words.4325b89e-3d42-4255-924b-c68f9f0e7d81.048.png)

### **修改检出配置**
当用户发现该安全事件不够精准，可以调整该安全事件对应事件检出配置。修改按钮位于事件处置区的上方。点击“按钮”触发事件配置弹窗。

![](/img/usage/Aspose.Words.4325b89e-3d42-4255-924b-c68f9f0e7d81.050.png)

## **设备画像**
设备信息提供涉事设备的以下信息，可以快速了解设备设备的身份属性。并提供快速跳转至更详细的威胁情报和活跃资产页面的快捷操作。

|类型|内容|
| - | - |
|威胁情报信息|<p>情报标签。</p><p>情报收录时间和更新时间。</p><p>情报来源。</p><p>威胁等级。</p>|
|地理位置信息|<p>国家、省份、城市。</p><p>经纬度。</p><p>时区。</p>|
|系统配置标签|<p>黑、白名单。</p><p>所属资产组。</p>|
|其他信息|运营商。|

## **行为时序变化**
告警时序变化模块可以让用户可以轻松地观察事件的时序特征，提升对安全事件的认知，配合其他模块能够得出攻击模式、攻击规律、脚本还是人为等多种有效信息。此外，系统还会自动计算和整理时序特征以及告警值特征，放置于图的右侧供用户参考。

![](/img/usage/Aspose.Words.4325b89e-3d42-4255-924b-c68f9f0e7d81.051.png)


通过该图我们可以清楚观察到事件的行为特征，例如下图中，左图的事件时序规律为仅发生在白天的8：30至18：00，期间不间断攻击，并且节假日也在持续，结合设备画像，可以推测是某台员工的工作设备，并且每日自动执行攻击程序；右图则是仅发生在每日的凌晨1:15，则可能是机器上设置了定时任务。

![](/img/usage/Aspose.Words.4325b89e-3d42-4255-924b-c68f9f0e7d81.052.png)


告警时序图的刷选的时间就是下方动作特征图谱以及事件相关特征展示数据的时间范围。

![](/img/usage/Aspose.Words.4325b89e-3d42-4255-924b-c68f9f0e7d81.053.png)


时序图支持以下操作

|名称|场景|操作|
| - | - | - |
|切换时间|查看更长时间范围下的时序规律|<p>点击“时间范围”执行快捷操作。</p><p>或者在时间选择器中自由切换时间。</p>|
|刷选|查看某些离散行为的详细证据。|1. 按住鼠标左键刷选目标离散行为。|
|提示框|查看离散事件的具体告警值和准备发生时间|1. 将鼠标移动至离散事件柱体上方。|

## **动作特征图谱**
动作特征图谱受行为时序图的控制，会展示该安全事件在上面时序图中所选时间范围内的相关的动作数据来进行佐证，并以可视化的表达绘制动作特征图谱。例如TCP扫描事件，特征图谱就会展示两个设备之间的TCP主动握手动作。

![](/img/usage/Aspose.Words.4325b89e-3d42-4255-924b-c68f9f0e7d81.055.png)


特征图谱是将每一次的动作按照发生时间、字节量、会话量、包大小以及双方设备端口等维度绘制成一条曲线，最终多条曲线形成一张该安全事件特有的动作图谱。此外，系统还会自动计算动作的数据特征，并放置于图谱右侧供查阅参考。

特征图谱能够帮助用户更好的证明安全事件的真伪性以及网络侧的攻击特征。例如下图中，我们可以得到以下信息：

|类型|特征|总结|结论|
| - | - | - | - |
|真伪|<p>红线在端口坐标轴上涵盖了从0-65535全部端口。</p><p>流量非常小。</p><p>时间坐标轴上非常的集中，说明时间很短。</p><p>扫描源对受害设备在5分钟内进行了106次的TCP发起握手动作。</p>|<p>1. 扫描源在极短的时间内，对受害设备的单位到高危端口发起了106次TCP握手动作。</p><p>2. 扫描源扫了受害设备100个端口。平均每个端口访问一次</p>|确定是TCP扫描|
|手法特征|红线在端口坐标轴上分布上非常均匀，并且间隔的很有规律。|被扫端口涵盖了低位和高位端口，并且是跨越式的扫描，扫描间隔和扫描内容的宽度相似。由此得到了攻击手法|均匀跨端口扫描|

![](/img/usage/Aspose.Words.4325b89e-3d42-4255-924b-c68f9f0e7d81.056.png)


特征图谱支持的操作如下：

|名称|场景|操作|
| - | - | - |
|更改采样量|<p>由于动作特征数据量有可能会很大从而影响用户体验，所以对动作特征加了一个限制，默认采样1000条。</p><p>如果在某些场景下想看到1000条以上的数据，可以更改采样量。</p>|<p>修改采样数量的值。</p><p>点击“刷新”。</p>|

## **事件相关特征**
事件相关特征，展示的是检测该事件时相关的Flow数据，也就是该事件的直接证据。事件相关特征也受告警时序图的限制，展示的是告警时序图选中的时间范围内相关特诊数据。

针对于不同的事件类型，事件相关特征表格展示的数据维度也不一样。针对于包内容检测出来的事件，特征表格每一列会有“展开”按钮，点开后，可以查看详细的包内容。

![](/img/usage/Aspose.Words.4325b89e-3d42-4255-924b-c68f9f0e7d81.059.png)

特征表格支持的操作如下：

|名称|场景|操作|
| - | - | - |
|数据导出|想要将特征数据导出系统。|选择想要导出数据条目，不选择则全部导出。点击“导出数据”，出现导出弹窗。选择文件类型和导出字段。点击“导出”。|
|查看包内容|仅针对于包检测事件|点击具体条目最左边的按钮。|
|更改采样|想要看更多的证据数据|<p>修改表头右侧的采样数量。</p><p>点击“刷新”。</p>|
