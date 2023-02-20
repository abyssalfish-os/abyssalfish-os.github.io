---
title: ESXi环境流量镜像接入说明
linktitle: 流量镜像接入
description: 以ESXi环境下流量接入配置为例，说明如何接入外部或内部的流量
date: 2023-02-20
publishdate: 2023-02-20
categories: [other,deploy]
keywords: [dev,docs,deploy]
menu:
  docs:
    parent: "other"
    weight: 10
weight: 10
sections_weight: 10
toc: true
isCJKLanguage: true
---

## ESXi环境采集流量镜像

### 前言
本文以ESXi环境下流量接入配置为例，说明如何将外部或内部的流量，接入到ESXi平台某台虚拟机的虚拟网卡上（流量采集节点）。
用户可以参考本文，根据自身实际环境进行流量接入的设置。

### 外部流量镜像接入
外部流量镜像接入过程可以概括为：接入待分析流量数据到物理网卡，新建虚拟交换机（vSwitch）接入从物理网卡（vmnic）采集到的数据，新建端口组（Network）建立虚拟交换机上的对外接口，再到分析平台所在虚拟机新建虚拟机网卡（vm）接入流量数据。
具体操作步骤如下：

1. 在网络管理页面，网络标签下，新建虚拟交换机（图中vSwitch3-Mirror），配置“上行链路”为已接入流量的物理网卡（图中vmnic4）。“安全”标签下，虚拟交换机的“允许混杂模式”配置为“是”。

![esxi_1](/img/esxi/esxi_1.png)

2. 在网络管理页面，新建端口组（图中Mirror1），绑定到接入流量的虚拟交换机（图中vSwitch3-Mirror）。“安全”标签下端口组的“允许混杂模式”配置为“接受”。

![esxi_2](/img/esxi/esxi_2.png)

3. 在运行分析程序的虚拟机的管理页面，添加网络适配器，绑定到流量镜像端口组（图中Mirror1）。

![esxi_3](/img/esxi/esxi_3.png)

至此，从外部流量镜像到虚拟机网卡的配置完毕，虚拟交换机上网络链接关系如下图所示：

![esxi_4](/img/esxi/esxi_4.png)


### 从内部接入流量镜像
内部流量镜像接入过程可以概括为：找到待分析流量数据所在虚拟交换机，在虚拟交换机（vSwitch）新建一个端口组（Network）用作流量采集，再把虚拟机网卡（vm）接入这个端口组采集数据。
具体操作步骤如下：

1. 在网络管理页面，定位到待分析目标流量所在的虚拟交换机（vSwitch/vDSwitch），记录该虚拟交换机名称（图中vSwitch1-LAN），进入该虚拟交换机配置页面，将该虚拟交换机的“允许混杂模式”配置为“是”。

![esxi_5](/img/esxi/esxi_5.png)

2. 在网络管理页面，新建端口组（图中MirrorLAN），绑定到接入流量的虚拟交换机（图中vSwitch1-LAN）。“安全”标签下端口组的“允许混杂模式”配置为“接受”。

![esxi_6](/img/esxi/esxi_6.png)

3. 在运行分析程序的虚拟机的管理页面，添加网络适配器，绑定到流量镜像端口组（图中MirrorLAN）。

![esxi_7](/img/esxi/esxi_7.png)

至此，从内部流量镜像到虚拟机网卡的配置完毕，虚拟交换机上网络链接关系如下图所示：

![esxi_8](/img/esxi/esxi_8.png)

进入流量分析平台所在虚拟机操作系统，配置新网卡进入混杂模式，从该网卡即可采集到流量镜像数据。

###  联系反馈

* 联系邮箱：[opensource@abyssalfish.com.cn](mailto:opensource@abyssalfish.com.cn)

