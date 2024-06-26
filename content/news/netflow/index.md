---
date: 2023-05-31
publishdate: 2023-05-31
title: "流影之NetFlow应用"
description: "NetFlow 技术概要，流影基于NetFlow进行异常网络行为发现的简介"
categories: ["categories"]
isCJKLanguage: true
draft: false
---

## 前言
前期已经发布一系列流影功能使用介绍的Blog，能够帮助大家理解流影的功能和应用场景。如果没有看过的话建议大家阅读，并在自己部署的实例或提供的演示Demo中进行操作熟悉。

网络数据是网络行为分析识别的基石，流影系统从数据采集到分析和呈现的过程中，留存了丰富的网络数据类型。本文是关于流影中相关数据类型介绍系列文章的首发篇，主要介绍流影中采集的NetFlow数据概要及其在行为识别中的应用。


## NetFlow简介
NetFlow最早在上世纪九十年代，由思科（Cisco）公司发明，被应用于其网络设备中对数据交换的加速，同时实现IP数据流的统计测量。思科的NetFlow技术，集成在其嵌入式网络硬件的互联网操作系统（IOS）中，是一套完整的技术解决方案，其中包括了数据交换的加速、数据流统计测量、数据导出和收集分析等相关技术。NetFlow开始是纯软件实现的形式，随着技术的发展，其中数据交换加速的功能逐渐被集成到专用的ASIC芯片中，其他功能依然是软件形式被应用。NetFlow能够提供网络运行中比较详细的统计信息，被广泛应用于IP流量统计计费、Qos等流量管理方面，后来在网络安全中也发挥了很大作用，如攻击检测等。

从数据内容上看，Netflow是一种网络流数据，其内容包含的是IP流上数据包相关统计信息。NetFlow最早版本V1，发展演变到最新是V9版本，其中应用比较多的是V5版本。最新的V9版本采用了基于模板的数据输出格式，比较灵活，可扩展性强，目前应用范围也越来越大。IEIF更是基于NetFlow V9版本，制定了IP数据流信息输出标准：IPFIX(IP Flow Information Export)。

NetFlow中的流（Flow)，其含义为IP之间会话中产生的单向数据包传输流。这里简要介绍其数据格式内容。
通常一个IP流的标识包括：源IP、目的IP、源端口、目的端口、协议类型、服务类型(ToS)、输入逻辑接口。相同标识的数据包信息，被跟踪统计，相应被测量计入其对应IP流的数据中，最终形成Flow数据。下面是一条简单IP流数据格式示例：

```
源地址|目的地址|源自治域|目的自治域|流入接口号|流出接口号|源端口|目的端口|协议类型|包数量|字节数|流数量

1.1.1.1|2.2.2.2|666|Others|9|13|12345|9000|6|10|1024|1
```
更详细的数据格式，可以参见[NetFlow V9官方文档](https://www.cisco.com/en/US/technologies/tk648/tk362/technologies_white_paper09186a00800a3db9.html)。

值得一提的是，有许多厂商比如华为、Juniper、HP等，也提出了不同于NetFlow类似的技术，如Juniper提出了CFlowd，华为提出的NetStream技术，这两种与NetFlow比较相近；还有一种不同于NetFlow的技术，sFlow技术对数据包进行了采样收集，性能要求更高，一般被集成在硬件的专用芯片中。

NetFlow相关技术已经发展很多年，其实现方式也比较灵活，包括使用硬件加速器、软件代理和网络设备等。NetFlow能够提供比较准确和时效性比较高的网络状态信息，帮助网络运行管理人员更好地了解网络状态。NetFlow在网络运营商中具有广泛的应用，比如网络流量和流向监控、客户流量计费、审计监控、故障定位等。NetFlow在网络安全领域也有比较成熟的应用，主要用于网络攻击入侵的检测发现，例如DDos攻击、网络扫描。

## NetFlow在网络安全中应用
NetFlow作为一种重要的网络流量分析技术，在网络安全、网络监控、流量工程等方面有着广泛的应用。

NetFlow数据记录了网络会话过程中的数据包的关键统计信息，每种攻击流量都会形成比较特别的流记录，一般称之为流特征。利用这些流特征，能够检测发现网络攻击行为。
下面简要介绍其在网络安全中的几个比较成熟的应用场景。

### DDos、Dos拒绝服务攻击检测
拒绝服务和分布式拒绝服务攻击，破坏目标服务的可用性为主要目的。最常见的攻击包括带宽攻击和连通性攻击。带宽攻击指以极大的通信量冲击网络，使得所有可用网络资源都被消耗殆尽，最后导致合法的用户请求无法通过。连通性攻击指用大量的连接请求冲击计算机，使得所有可用的操作系统资源都被消耗殆尽，最终计算机无法再处理合法用户的请求（百度百科）。
常用的攻击方式包括SYN Flood、IP 欺骗、UDP Flood、ICMP Flood等。

拒绝服务攻击造成服务器无法处理源源不断如潮水般涌来的请求，从而造成响应迟缓，直至系统资源耗尽而宕机。攻击特点是请求来源广泛，针对目标主机，发送大量数据包。
拒绝服务攻击发生时，具有比较显著的流特征，由于短时间内大量IP对目标的连接，这时会形成大量源IP不同，目的IP相同的流数据;这些流数据的包数、字节数基本一样。一个典型的SYN Flood攻击流特征示例如下，出现大量40字节的流记录：

```
11.*.*.45|222.*.*.3|Others|64851|3|2|9999|10000|6|1|40|1
10.*.*.81|222.*.*.3|Others|64851|3|2|8888|10000|6|1|40|1 
8.*.*.111|222.*.*.3|Others|64851|3|2|6666|10000|6|1|40|1
21.*.*.12|222.*.*.3|Others|64851|3|2|7777|10000|6|1|40|1
100.*.*.16|222.*.*.3|Others|64851|3|2|5678|10000|6|1|40|1 
88.*.*.36|222.*.*.3|Others|64851|3|2|8967|10000|6|1|40|1
...
```

### 网络扫描检测
恶意攻击者利用网络扫描收集目标资产信息，以发现目标漏洞进行利用为目的，一般发生在攻击的开始的早期阶段，或者出现在攻陷目标后的横向渗透阶段。网络扫描包括IP扫描和端口扫描。IP扫描主要用于发现存活目标主机，端口扫描用于发现目标上开放的服务。

网络扫描过程中往往会想目标主机发送大量特征一致的探测包，形成的Flow数据也具有相似的特征。例如IP扫描时，会出现源IP相同，大量目标IP邻近的流记录。端口扫描时，会出现目标端口大范围分布，甚至是连续端口范围内顺序出现的流记录。如下面所示，针对一个网段IP的固定端口扫描的流记录示例：
```
111.*.*.5|167.*.210.95|65211|2|10|1028|137|17|1|78|1
111.*.*.5|167.*.210.96|65211|2|10|1028|137|17|1|78|1
111.*.*.5|167.*.210.97|65211|2|10|1028|137|17|1|78|1
111.*.*.5|167.*.210.98|65211|2|10|1028|137|17|1|78|1
111.*.*.5|167.*.210.99|65211|2|10|1028|137|17|1|78|1
111.*.*.5|167.*.210.100|65211|2|10|1028|137|17|1|78|1
...
```

### 其它网络攻击异常检测
某些计算机病毒在网络上传播时，会产生具有共同特点的网络流特征。可以通过计算病毒传播中的流特征，快速发现异常。例如早些年前出现的CodeRed蠕虫，其Flow特征是目标端口80，包数为3，包大小为144字节的大量报文。震荡波蠕虫传播时会同时相随机生成的目标IP的445端口进行连接，因此会出现大量目标IP和端口为445的相同流记录。因此基于相关流特征，在一定时间窗口内设定基于阈值的检测规则，就可以实现一些网络攻击行为的识别发现。




## 流影中NetFlow的应用
### NetFlow数据采集
流影系统集成了网络流量探针ly_probe，该探针基于开源高性能探针nprobe的5.X版本进行了深度定制化开发，在实际测试和部署应用中，表现出良好的采集吞吐性能，并且在高速流量中仍然能保持比较低的丢包率。

流影通过ly_probe采集基础数据，其中的NetFlow数据，使用的是V9版本的格式。在ly_probe节点，如果采用的是默认安装，可以在/etc/rc.local中看到其运行的命令，如下图所示：

![ly_probe](./ly_probe_cmd.png)

其中-T参数指定了采集的数据字段，-i指定网卡接口，-n指定数据导出目的IP端口，-K指定的是pcap留存的路径。上面的命令表明采集的Flow数据被发送到本机的9995端口。

Flow数据如何收集的呢？流影使用的是开源网络数据收集和处理组件[nfdump](https://github.com/phaag/nfdump)。在流影中主要使用的相关命令如下所示：
```
/Agent/bin/nfcapd -w -D -l /data/flow/3 -p 9995
```
该命令监听9995端口，收集Flow数据，将数据以文件形式保存在目录/data/flow/3中。默认nfcapd配置每5分钟保存一个数据文件。如下图所示：

![nfd](./nf_file.png)

nfcapd.xxx即采集的Flow数据文件，可以看出每5分钟生成一个新数据文件，使用nfdump可以查看数据文件的详细内容，命令示例如下。
```
/Agent/bin/nfdump -r /data/flow/3/nfcapd.202305302215
```

输出的Flow数据如下图所示：
![nfsee](./dump_flow.png)
nfdump输出了易读的Flow格式化数据，每一行是一条Flow统计数据，主要包含了IP会话流的时间信息、源和目的IP、源和目的端口、协议类型、包数、字节数据及流数量。


流影探针一般部署在企业网络入口或者出口处，采集到比较全面的流量数据。如果客户使用了支持NetFlow的路由器（思科的大部分路由器都支持此功能），本质上也可以支持直接接入从路由器采集的NetFlow数据（暂未经过实测）。需要指出的是，流影探针不只采集了NetFlow数据，也采集了网络行为的通信过程中部分数据包，这部分功能后续另写文章再进行介绍。

### 流影基于NetFlow数据的异常发现
NetFlow数据是流影的基础数据之一，采集的Flow数据会持续进入流影后续的聚合分析过程，作为输入经过相关模型的检测，最终输出分析结果数据，形成事件告警；另一方面，利用这些流数据，在用户界面绘制了直观的网络流量图形，力求让用户对网络流量情况和异常行为与威胁行为能够一目了然。以下从流影演示环境中选取几个示例进行说明。


#### 异常服务发现

发现异常服务的前提，首先需要发现服务，可以通过netflow数据描绘的会话连接信息，推断出提供网络服务的设备IP与端口。随后基于目标服务的会话数量、响应频率、通信数据量等信息，发现数据的异常波动，推断服务存在的异常。

基于NetFlow数据，开源流影内置了三个异常服务(模型)规则，分别是异常服务通信、SSH异常和RDP异常。这些模型对资产标签内同一目的IP、目的端口上的会话量进行统计，当在监控周期内超出设定的端口会话阈值时，即报告异常告警事件。在配置界面可以查看其相关配置，如下图所示。

![异常服务配置](./ly_flow_0.png)

这些检测规则都是简单的统计模型，阈值可以根据实际情况进行调整。管理员权限用户可以修改其中规则配置项，并对监控目标新建类似的规则。下面是其中对RDP服务的监控配置。

![RDP异常监控](./ly_flow_1.png)


在事件菜单界面下，筛选查询区域的事件类型中选择“异常服务”，即可查看检测出的异常服务告警事件分布情况，如下图所示。

![异常事件](./ly_flow_2.png)

该界面最下方显示异常服务告警事件列表，如下图所示。
![异常服务](./ly_flow_3.png)


在事件列表中点击一条告警的ID，即可跳转到该告警的详情界面，基于FLow特征数据绘制了告警发生的时序变化图形，帮助用户分析发现通信时间规律；同时基于FLow特征数据绘制了TCP主动握手时序分布图，将NetFlow数据特征进行可视化，帮助用户看清IP会话通信特征，让异常行为或者威胁行为一目了然。如下图所示。

![异常服务-详情1](./ly_flow_4.png)

告警事件详情页面最下方显示了该异常事件的所有Flow特征数据列表，用户可以查看详细数据或者进行导出。
![异常服务-详情2](./ly_flow_5.png)


#### 扫描行为发现
流影通过对netflow数据的聚合分析，在一定时间尺度上，发现特定目标的规律性请求。
基于NetFlow数据，开源流影集成了两类网络扫描模型，IP扫描和端口扫描。流影中IP扫描的检测模型，通过对相同源IP、相同目的IP上不同目的端口数量进行统计，设定告警规则为当在时间窗口内对端端口数量超过阈值后，即产生IP扫描类型告警事件。端口扫描事件的检测模型，通过相同源IP、相同目的端口上不同目的IP数量进行统计，设定告警规则为当指定的扫描端口上IP数量超过规定的阈值后，即产生端口扫描类型的告警事件。

类似上文中的操作，用户可以在事件页面筛选出扫描行为告警，以端口扫描告警事件为例进行说明，如下图所示。

![端口扫描](./ly_port_0.png)

点击事件ID，进入扫描告警详情页面，查看相关图表，基本可以确认扫描行为。如下图所示。

![端口扫描-详情1](./ly_port_1.png)

还可以在详情页最下方的列表查看详细的流特征数据，并支持数据导出到文件。

![端口扫描-详情2](./ly_port_2.png)


以上就是对流影中应用NetFlow进行异常行为检测的简介。当然，流影基于Flow数据的应用不只是这些，其它诸如服务器外联、数据泄露、隧道通信等异常网络行为，都利用了NetFlow数据特征。建议用户结合本文的介绍以及之前发布的功能讲解文章，在自己部署的实例或者演示环境中进行操作实践。希望本文能够帮助大家更好的理解和使用流影系统，在用户的网络安全防护实践中发挥更好的作用。


## 结语
NetFlow是一项发展多年并且十分成熟的网络流量监测技术，不仅可以协助实现网络流量的管理和监控，而且在网络安全中具有重要的应用价值，用于识别网络中的异常流量、检测网络攻击行为，提高网络安全感知和防护能力。应该指出的是，NetFlow也具有其局限性，如采集IP流信息的丰富度有限，并且流记录生成导出有一定的时延，不太适用于网络取证和时效性要求比较高的场景中。

流影系统利用探针采集了NetFlow数据，NetFlow作为流影基础数据之一，被广泛应用于许多网络行为的异常检测之中，并在流影的可视化界面中，对告警事件的流特征数据进行了列表展示和时序图的可视化，让用户更容易看清和看懂网络通信中异常行为。
