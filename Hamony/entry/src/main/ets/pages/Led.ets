import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

interface LightZone {
  id: number;
  name: string;
  area: string;
  status: boolean;
  brightness: number;
  powerConsumption: string;
  lastUpdate: string;
  deviceCount: number;
  lightType: string;
}

@Entry
@Component
struct LightingSystemPage {
  @State lightZones: Array<LightZone> = [];
  @State currentTime: string = '';
  @State totalDevices: number = 0;
  @State activeDevices: number = 0;
  @State totalPower: string = '0W';
  @State isLoading: boolean = false;

  aboutToAppear() {
    this.loadLightingData();
    this.updateTime();
    setInterval(() => {
      this.updateTime();
    }, 1000);
  }

  private loadLightingData() {
    this.lightZones = [
      {
        id: 1,
        name: '厂区一',
        area: 'A区生产车间',
        status: true,
        brightness: 85,
        powerConsumption: '2.5kW',
        lastUpdate: '2分钟前',
        deviceCount: 24,
        lightType: 'LED工业灯'
      },
      {
        id: 2,
        name: '厂区二',
        area: 'B区装配车间',
        status: false,
        brightness: 0,
        powerConsumption: '0W',
        lastUpdate: '10分钟前',
        deviceCount: 18,
        lightType: '荧光灯'
      },
      {
        id: 3,
        name: '厂区三',
        area: 'C区仓储区域',
        status: true,
        brightness: 60,
        powerConsumption: '1.8kW',
        lastUpdate: '刚刚',
        deviceCount: 16,
        lightType: '节能灯'
      },
      {
        id: 4,
        name: '厂区四',
        area: 'D区办公区域',
        status: true,
        brightness: 75,
        powerConsumption: '1.2kW',
        lastUpdate: '5分钟前',
        deviceCount: 12,
        lightType: '护眼灯'
      },
      {
        id: 5,
        name: '厂区五',
        area: 'E区户外照明',
        status: false,
        brightness: 0,
        powerConsumption: '0W',
        lastUpdate: '1小时前',
        deviceCount: 20,
        lightType: '路灯'
      },
      {
        id: 6,
        name: '厂区六',
        area: 'F区停车场',
        status: true,
        brightness: 90,
        powerConsumption: '3.2kW',
        lastUpdate: '刚刚',
        deviceCount: 30,
        lightType: '泛光灯'
      }
    ];

    this.totalDevices = this.lightZones.reduce((sum, zone) => sum + zone.deviceCount, 0);
    this.activeDevices = this.lightZones.filter(zone => zone.status).length;

    const totalPowerNum = this.lightZones
      .filter(zone => zone.status)
      .reduce((sum, zone) => sum + parseFloat(zone.powerConsumption.replace(/[kW]/g, '')), 0);
    this.totalPower = `${totalPowerNum.toFixed(1)}kW`;
  }

  private updateTime() {
    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    this.currentTime = `${month}月${day}日 ${hours}:${minutes}`;
  }

  build() {
    Column() {
      this.buildHeader()

      Scroll() {
        Column() {
          this.buildWelcomeSection()
          this.buildQuickStats()
          this.buildLightingGrid()
        }
        .padding({ bottom: 30 })
      }
      .layoutWeight(1)
      .backgroundColor('#F8F9FA')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder
  buildHeader() {
    Row() {
      Button('<')
        .width(50)
        .height(32)
        .fontSize(16)
        .fontColor('#333333')
        .backgroundColor('#F0F0F0')
        .borderRadius(16)
        .onClick(() => {
          router.back()
        })

      Text('智能照明系统')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .textAlign(TextAlign.Center)
        .layoutWeight(1)

      Text(this.currentTime)
        .fontSize(12)
        .fontColor('#666666')
        .backgroundColor('#F0F0F0')
        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .borderRadius(8)
    }
    .width('100%')
    .height(60)
    .padding({ left: 20, right: 20, top: 10 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  buildWelcomeSection() {
    Column() {
      Text('管理您的智能照明设备')
        .fontSize(16)
        .fontColor('#333333')
        .margin({ bottom: 8 })

      Text('实时监控各厂区照明状态与能耗')
        .fontSize(14)
        .fontColor('#666666')
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 20, bottom: 25 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildQuickStats() {

  }

  @Builder
  buildStatsCard(title: string, value: string, unit: string) {
    Column() {
      Text(value)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .margin({ bottom: 4 })

      Text(title)
        .fontSize(11)
        .fontColor('#666666')
        .margin({ bottom: 2 })

      Text(unit)
        .fontSize(9)
        .fontColor('#999999')
    }
    .width(75)
    .height(70)
    .padding(10)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .border({
      width: 1,
      color: '#E5E5E5'
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildLightingGrid() {
    Column() {
      Grid() {
        ForEach(this.lightZones, (zone: LightZone, index: number) => {
          GridItem() {
            this.buildLightZoneCard(zone, index)
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

  @Builder
  buildLightZoneCard(zone: LightZone, index: number) {
    Column({ space: 12 }) {
      // 状态指示器和控制
      Row() {
        Row() {
          Circle({ width: 8, height: 8 })
            .fill(zone.status ? '#4CAF50' : '#CCCCCC')
            .margin({ right: 6 })

          Text(zone.status ? '在线' : '离线')
            .fontSize(11)
            .fontColor(zone.status ? '#4CAF50' : '#999999')
            .fontWeight(FontWeight.Medium)
        }

        Blank()

        Toggle({ type: ToggleType.Switch, isOn: zone.status })
          .width(36)
          .height(20)
          .selectedColor('#4CAF50')
          .switchPointColor(Color.White)
          .onChange((isOn: boolean) => {
            this.toggleZoneStatus(zone.id, isOn, index);
          })
      }
      .width('100%')

      // 厂区信息
      Column({ space: 6 }) {
        Text(zone.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Text(zone.lightType)
          .fontSize(10)
          .fontColor('#666666')
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .backgroundColor('#F5F5F5')
          .borderRadius(8)

        Text(zone.area)
          .fontSize(11)
          .fontColor('#999999')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)

      // 设备数量和功耗
      if (zone.status) {
        Row() {
          Column() {
            Text('设备')
              .fontSize(9)
              .fontColor('#999999')
              .margin({ bottom: 2 })
            Text(`${zone.deviceCount}台`)
              .fontSize(12)
              .fontColor('#333333')
              .fontWeight(FontWeight.Medium)
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text('功耗')
              .fontSize(9)
              .fontColor('#999999')
              .margin({ bottom: 2 })
            Text(zone.powerConsumption)
              .fontSize(12)
              .fontColor('#333333')
              .fontWeight(FontWeight.Bold)
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.End)
        }
        .width('100%')

        // 亮度控制
        Column({ space: 6 }) {
          Row() {
            Text('亮度')
              .fontSize(9)
              .fontColor('#999999')

            Blank()

            Text(`${zone.brightness}%`)
              .fontSize(10)
              .fontColor('#333333')
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')

          Slider({
            value: zone.brightness,
            min: 0,
            max: 100,
            style: SliderStyle.OutSet
          })
            .width('100%')
            .height(12)
            .trackColor('#E5E5E5')
            .selectedColor('#4CAF50')
            .trackThickness(4)
            .onChange((value: number) => {
              this.adjustBrightness(zone.id, value, index);
            })
        }
      } else {
        Column({ space: 6 }) {
          Text('设备离线')
            .fontSize(12)
            .fontColor('#999999')

          Text(zone.lastUpdate)
            .fontSize(10)
            .fontColor('#CCCCCC')
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ top: 8, bottom: 8 })
      }

      // 操作按钮
      Button(zone.status ? '查看详情' : '设备离线')
        .width('100%')
        .height(32)
        .fontSize(12)
        .backgroundColor(zone.status ? '#4CAF50' : '#E5E5E5')
        .fontColor(zone.status ? Color.White : '#999999')
        .borderRadius(16)
        .enabled(zone.status)
        .onClick(() => {
          if (zone.status) {
            this.viewZoneDetails(zone);
          }
        })
    }
    .width('100%')
    .height(240)
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .border({
      width: 1,
      color: '#E5E5E5'
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .shadow({
      radius: 4,
      color: 'rgba(0, 0, 0, 0.08)',
      offsetX: 0,
      offsetY: 2
    })
  }

  private toggleZoneStatus(zoneId: number, isOn: boolean, index: number): void {
    const zone = this.lightZones.find(z => z.id === zoneId);
    if (zone) {
      zone.status = isOn;
      zone.brightness = isOn ? 75 : 0;
      zone.lastUpdate = '刚刚';

      if (isOn) {
        const basePower = [2.5, 1.8, 1.8, 1.2, 2.0, 3.2][index];
        zone.powerConsumption = `${basePower}kW`;
      } else {
        zone.powerConsumption = '0W';
      }

      this.activeDevices = this.lightZones.filter(z => z.status).length;
      const totalPowerNum = this.lightZones
        .filter(z => z.status)
        .reduce((sum, z) => sum + parseFloat(z.powerConsumption.replace(/[kW]/g, '')), 0);
      this.totalPower = `${totalPowerNum.toFixed(1)}kW`;

      promptAction.showToast({
        message: `${zone.name} ${zone.lightType}已${isOn ? '开启' : '关闭'}`,
        duration: 2000
      });
    }
  }

  private adjustBrightness(zoneId: number, brightness: number, index: number): void {
    const zone = this.lightZones.find(z => z.id === zoneId);
    if (zone && zone.status) {
      zone.brightness = Math.round(brightness);
      zone.lastUpdate = '刚刚';

      const basePower = [2.5, 1.8, 1.8, 1.2, 2.0, 3.2][index];
      const newPower = (basePower * brightness / 100).toFixed(1);
      zone.powerConsumption = `${newPower}kW`;

      const totalPowerNum = this.lightZones
        .filter(z => z.status)
        .reduce((sum, z) => sum + parseFloat(z.powerConsumption.replace(/[kW]/g, '')), 0);
      this.totalPower = `${totalPowerNum.toFixed(1)}kW`;
    }
  }

  private viewZoneDetails(zone: LightZone): void {
    router.pushUrl({
      url: 'pages/LightZoneDetailPage',
      params: {
        zoneInfo: zone
      }
    }).catch((err: Error) => {
      promptAction.showToast({
        message: '页面跳转失败',
        duration: 2000
      });
    });
  }
}