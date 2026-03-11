import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

interface HostInfo {
  id: number;
  name: string;
  ip: string;
  status: string;
  client: string;
  backup: string;
  lastActiveTime?: string;
  cpuUsage?: string;
  memoryUsage?: string;
}

@Entry
@Component
struct HostListPage {
  @State hostData: Array<HostInfo> = [];
  @State filteredData: Array<HostInfo> = [];
  @State isLoading: boolean = true;
  @State searchValue: string = '';
  @State selectedFilter: string = '全部';
  @State refreshing: boolean = false;

  aboutToAppear() {
    this.loadHostData();
  }

  private loadHostData() {
    setTimeout(() => {
      this.hostData = [
        {
          id: 1,
          name: "机械臂1号",
          ip: "192.168.134.247",
          status: "正常在线",
          client: "已安装",
          backup: "全量备份",
          lastActiveTime: "2分钟前",
          cpuUsage: "65%",
          memoryUsage: "78%"
        },
        {
          id: 2,
          name: "机械臂2号",
          ip: "192.81.0.72",
          status: "离线",
          client: "未安装",
          backup: "--",
          lastActiveTime: "1小时前",
          cpuUsage: "--",
          memoryUsage: "--"
        },
        {
          id: 3,
          name: "机械臂3号",
          ip: "192.81.0.145",
          status: "维护中",
          client: "已安装",
          backup: "增量备份",
          lastActiveTime: "30分钟前",
          cpuUsage: "45%",
          memoryUsage: "56%"
        },
        {
          id: 4,
          name: "机械臂4号",
          ip: "192.81.0.91",
          status: "离线",
          client: "已安装",
          backup: "增量备份",
          lastActiveTime: "3小时前",
          cpuUsage: "--",
          memoryUsage: "--"
        },
        {
          id: 5,
          name: "机械臂5号",
          ip: "192.81.0.57",
          status: "正常在线",
          client: "未安装",
          backup: "--",
          lastActiveTime: "刚刚",
          cpuUsage: "82%",
          memoryUsage: "91%"
        }
      ];
      this.filteredData = this.hostData;
      this.isLoading = false;
      this.refreshing = false;
    }, 1000);
  }

  private filterHosts(keyword: string) {
    if (!keyword.trim()) {
      this.filteredData = this.hostData;
      return;
    }

    const lowerKeyword = keyword.toLowerCase();
    this.filteredData = this.hostData.filter(item =>
    item.name.toLowerCase().includes(lowerKeyword) ||
    item.ip.toLowerCase().includes(lowerKeyword)
    );
  }

  private filterByStatus(status: string) {
    this.selectedFilter = status;
    if (status === '全部') {
      this.filteredData = this.hostData;
    } else {
      this.filteredData = this.hostData.filter(item => item.status === status);
    }
  }

  private handleActivate(hostInfo: HostInfo) {
    // 直接跳转到详情页面，不再显示弹窗确认
    router.pushUrl({
      url: 'pages/StartUpPage',
      params: {
        hostInfo: hostInfo
      }
    });
  }

  private onRefresh() {
    this.refreshing = true;
    this.loadHostData();
  }

  build() {
    Stack() {
      // 背景图片
      Image($r("app.media.img"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 主要内容
      Column() {
        // 顶部导航栏
        this.buildHeader()

        // 主体内容区域
        Scroll() {
          Column() {
            // 欢迎区域
            this.buildWelcomeSection()

            // 快速统计
            this.buildQuickStats()

            // 搜索和筛选
            this.buildSearchAndFilter()

            // 机械臂网格列表
            this.buildRobotGrid()
          }
          .padding({ bottom: 20 })
        }
        .layoutWeight(1)
        .backgroundColor('rgba(255, 255, 255, 0.05)')
        .backdropBlur(10)
      }
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  buildHeader() {
    Row() {
      Button('<')
        .width(60)
        .height(36)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .backgroundColor('rgba(255, 255, 255, 0.8)')
        .borderRadius(18)
        .onClick(() => {
          router.back()
        })

      Text('机械臂控制中心')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .textAlign(TextAlign.Center)
        .layoutWeight(1)

      Row() {
        Button('设置')
          .width(70)
          .height(32)
          .fontSize(12)
          .backgroundColor('rgba(255, 255, 255, 0.8)')
          .fontColor('#1A1A1A')
          .borderRadius(16)
          .onClick(() => {
            // 设置页面
          })
      }
    }
    .width('100%')
    .height(60)
    .padding({ left: 20, right: 20, top: 10 })
  }

  @Builder
  buildWelcomeSection() {
    Column() {
      Text('管理您的智能机械臂设备')
        .fontSize(16)
        .fontColor('#333333')
        .margin({ bottom: 20 })

      // 时间显示
      Text(this.getCurrentTime())
        .fontSize(14)
        .fontColor('#666666')
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 20, bottom: 30 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildQuickStats() {

  }

  @Builder
  buildGlassCard(title: string, value: string, unit: string, color: string) {
    Column() {
      Text(value)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
        .margin({ bottom: 4 })

      Text(title)
        .fontSize(12)
        .fontColor('#1A1A1A')
        .margin({ bottom: 2 })

      Text(unit)
        .fontSize(10)
        .fontColor('#666666')
    }
    .width(75)
    .height(80)
    .padding(12)
    .backgroundColor('rgba(255, 255, 255, 0.7)')
    .backdropBlur(20)
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildSearchAndFilter() {
    Column() {
      // 状态筛选
      Row() {
        this.buildFilterChip('全部')
        this.buildFilterChip('正常在线')
        this.buildFilterChip('离线')
        this.buildFilterChip('维护中')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .padding({ left: 20, right: 20 })
    .margin({ bottom: 25 })
  }

  @Builder
  buildFilterChip(status: string) {
    Text(status)
      .fontSize(12)
      .fontColor(this.selectedFilter === status ? Color.White : '#1A1A1A')
      .backgroundColor(this.selectedFilter === status ? '#007AFF' : 'rgba(255, 255, 255, 0.8)')
      .backdropBlur(10)
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .borderRadius(20)
      .border({
        width: 1,
        color: this.selectedFilter === status ? '#007AFF' : 'rgba(0, 0, 0, 0.1)'
      })
      .onClick(() => {
        this.filterByStatus(status);
      })
  }

  @Builder
  buildRobotGrid() {
    Column() {
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .color('#007AFF')
            .width(40)
            .height(40)
            .margin({ bottom: 12 })

          Text('加载设备中...')
            .fontSize(14)
            .fontColor('#666666')
        }
        .width('100%')
        .height(200)
        .justifyContent(FlexAlign.Center)
      }
      else if (this.filteredData.length === 0) {
        Column() {
          Text('🤖')
            .fontSize(48)
            .margin({ bottom: 12 })

          Text('暂无匹配的设备')
            .fontSize(14)
            .fontColor('#666666')
        }
        .width('100%')
        .height(200)
        .justifyContent(FlexAlign.Center)
      }
      else {
        Grid() {
          ForEach(this.filteredData, (item: HostInfo) => {
            GridItem() {
              this.buildRobotCard(item)
            }
          })
        }
        .columnsTemplate('1fr 1fr')
        .rowsGap(16)
        .columnsGap(16)
        .width('100%')
        .padding({ left: 20, right: 20 })
      }
    }
  }

  @Builder
  buildRobotCard(hostInfo: HostInfo) {
    Column() {
      // 状态指示器
      Row() {
        Circle({ width: 10, height: 10 })
          .fill(this.getStatusColor(hostInfo.status))
          .margin({ right: 8 })

        Text(hostInfo.status)
          .fontSize(12)
          .fontColor('#1A1A1A')
          .layoutWeight(1)

        Text(hostInfo.lastActiveTime || '--')
          .fontSize(10)
          .fontColor('#666666')
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 设备名称
      Text(hostInfo.name)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 8 })
        .textAlign(TextAlign.Center)

      // IP地址
      Text(hostInfo.ip)
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 12 })

      // 性能指标
      if (hostInfo.status === '正常在线') {
        Row() {
          Column() {
            Text('CPU')
              .fontSize(10)
              .fontColor('#666666')
              .margin({ bottom: 2 })
            Text(hostInfo.cpuUsage || '--')
              .fontSize(12)
              .fontColor('#1A1A1A')
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)

          Column() {
            Text('内存')
              .fontSize(10)
              .fontColor('#666666')
              .margin({ bottom: 2 })
            Text(hostInfo.memoryUsage || '--')
              .fontSize(12)
              .fontColor('#1A1A1A')
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)
        }
        .width('100%')
        .margin({ bottom: 16 })
      } else {
        Blank()
          .height(30)
      }

      // 操作按钮
      Button(hostInfo.status === '离线' ? '设备离线' : '查看详情')
        .width('100%')
        .height(30)
        .fontSize(12)
        .backgroundColor(hostInfo.status === '离线' ? '#CCCCCC' : '#007AFF')
        .fontColor(hostInfo.status === '离线' ? '#666666' : Color.White)
        .borderRadius(18)
        .enabled(hostInfo.status !== '离线')
        .onClick(() => {
          this.handleActivate(hostInfo);
        })
    }
    .width('100%')
    .height(190)
    .padding(16)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(20)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  private getStatusColor(status: string): string {
    switch (status) {
      case '正常在线':
        return '#66BB6A';
      case '离线':
        return '#EF5350';
      case '维护中':
        return '#FF7043';
      default:
        return '#9E9E9E';
    }
  }

  private getCurrentTime(): string {
    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    return `${month}月${day}日 ${hours}:${minutes}`;
  }
}