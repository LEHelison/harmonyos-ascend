import router from '@ohos.router'
import { promptAction } from '@kit.ArkUI'
import http from '@ohos.net.http';

interface Device {
  id: number;
  name: string;
  type: string;
  status: 'online' | 'offline' | 'standby';
  category: string;
  zone: string; // 新增区域字段
  lastActive: string;
  batteryLevel?: number;
}
const token: string = "MIINmgYJKoZIhvcNAQcCoIINizCCDYcCAQExDTALBglghkgBZQMEAgEwggusBgkqhkiG9w0BBwGgggudBIILmXsidG9rZW4iOnsiZXhwaXJlc19hdCI6IjIwMjUtMDYtMjFUMDg6MTg6NDkuMjcyMDAwWiIsIm1ldGhvZHMiOlsicGFzc3dvcmQiXSwiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJyb2xlcyI6W3sibmFtZSI6InRlX2FkbWluIiwiaWQiOiIwIn0seyJuYW1lIjoic2VjdV9hZG1pbiIsImlkIjoiMCJ9LHsibmFtZSI6InRlX2FnZW5jeSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVwX2FjY2VsZXJhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19kaXNrQWNjIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZHNzX21vbnRoIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb2JzX2RlZXBfYXJjaGl2ZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGgtNGMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kZWNfbW9udGhfdXNlciIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Nicl9zZWxsb3V0IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX29sZF9yZW91cmNlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX1JveWFsdHkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF93ZWxpbmticmlkZ2VfZW5kcG9pbnRfYnV5IiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfY2JyX2ZpbGUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9kbXMtcm9ja2V0bXE1LWJhc2ljIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWthZmthMyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX29ic19kZWNfbW9udGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jc2JzX3Jlc3RvcmUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfdm13YXJlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaWRtZV9tYm1fZm91bmRhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19jNmEiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9tdWx0aV9iaW5kIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfc21uX2NhbGxub3RpZnkiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0zZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcHJvZ3Jlc3NiYXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jZXNfcmVzb3VyY2Vncm91cF90YWciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9hYzciLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcmV0eXBlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfa29vbWFwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZXZzX2Vzc2QyIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZG1zLWFtcXAtYmFzaWMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9ldnNfcG9vbF9jYSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfY24tc291dGh3ZXN0LTJiIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfaHdjcGgiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9lY3Nfb2ZmbGluZV9kaXNrXzQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9od2RldiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl93ZWxpbmtyZWQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9odl92ZW5kb3IiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9jbi1ub3J0aC00ZCIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2Vjc19oZWNzX3giLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9jYnJfZmlsZXNfYmFja3VwIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2FjNyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2VwcyIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2NzYnNfcmVzdG9yZV9hbGwiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2NuLW5vcnRoLTRmIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfb3BfZ2F0ZWRfcm91bmR0YWJsZSIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19leHQiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9wZnNfZGVlcF9hcmNoaXZlIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9hcC1zb3V0aGVhc3QtMWUiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX3J1LW1vc2Nvdy0xYiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2FfYXAtc291dGhlYXN0LTFkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYXBwc3RhZ2UiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9hX2FwLXNvdXRoZWFzdC0xZiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX3Ntbl9hcHBsaWNhdGlvbiIsImlkIjoiMCJ9LHsibmFtZSI6Im9wX2dhdGVkX2V2c19jb2xkIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfcmRzX2NhIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX2dwdV9nNXIiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9vcF9nYXRlZF9tZXNzYWdlb3ZlcjVnIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfZWNzX3JpIiwiaWQiOiIwIn0seyJuYW1lIjoib3BfZ2F0ZWRfYV9ydS1ub3J0aHdlc3QtMmMiLCJpZCI6IjAifSx7Im5hbWUiOiJvcF9nYXRlZF9pZWZfcGxhdGludW0iLCJpZCI6IjAifV0sImlzc3VlZF9hdCI6IjIwMjUtMDYtMjBUMDg6MTg6NDkuMjcyMDAwWiIsInVzZXIiOnsiZG9tYWluIjp7Im5hbWUiOiJ6aHIxNjgtIiwiaWQiOiJlYTY2YjgyNTI0NDE0ZmFlYTQ4OWExY2QwYTg5ZDY5MCJ9LCJuYW1lIjoieXdiIiwicGFzc3dvcmRfZXhwaXJlc19hdCI6IiIsImlkIjoiN2QwMzcyMTBjY2ZkNDhjNWI2ODk4MzA2ZGE3MjcyMTUifX19MYIBwTCCAb0CAQEwgZcwgYkxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAlHdWFuZ0RvbmcxETAPBgNVBAcMCFNoZW5aaGVuMS4wLAYDVQQKDCVIdWF3ZWkgU29mdHdhcmUgVGVjaG5vbG9naWVzIENvLiwgTHRkMQ4wDAYDVQQLDAVDbG91ZDETMBEGA1UEAwwKY2EuaWFtLnBraQIJANyzK10QYWoQMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAScr9ZR3jrpKIGg1-qoKREMKomJ5tcLNVxE7Sm7JwlWrZH+43SOmWcO1q2KZ5iV8ZrEDV9XPa8fgotuY+rOVCEUAgMdKQUay0YdTbUCxtyks-bpXHouaVRzcN9ckUx7iHdP1LEaREuFiHrcvSnyM9TExvQsi0OGADpMtJiMFtZpz5eId5x3BRI3WKW1qbLzBAnXrDkOgmSb+bYCBymcwszwkSP1g+z3nF22VUis8LsAXpYdhQ+aH8kW4A-w09w3L+Bvoo9sCOIZfw7rie7GsbgN1OM0HCs53wotFXy69sfMUmDp0IiOE1vBaifOfSA6KrEET4A2CE0ASFp+9jii8oQ"
@Entry
@Component
struct RemoteControlPage {
  @State message: string = 'Hello World'
  @State devices: Device[] = [
    {
      id: 1,
      name: '厂区一A区',
      type: '五醒跑马灯',
      status: 'online',
      category: 'lighting1',
      zone: '厂区一',
      lastActive: ''
    },
    {
      id: 2,
      name: '厂区一B区',
      type: '五醒跑马灯',
      status: 'online',
      category: 'weighing',
      zone: '厂区一',
      lastActive: ''
    },
    {
      id: 3,
      name: '厂区二A区',
      type: '五醒跑马灯',
      status: 'online',
      category: 'lighting2',
      zone: '厂区二',
      lastActive: ''
    },
    {
      id: 4,
      name: '厂区二B区',
      type: '五醒跑马灯',
      status: 'online',
      category: 'weighing',
      zone: '厂区二',
      lastActive: ''
    },
    {
      id: 5,
      name: '厂区三A区',
      type: '五醒跑马灯',
      status: 'online',
      category: 'lighting3',
      zone: '厂区三',
      lastActive: ''
    },
    {
      id: 6,
      name: '厂区三B区',
      type: '五醒跑马灯',
      status: 'online',
      category: 'weighing',
      zone: '厂区三',
      lastActive: ''
    },
    {
      id: 7,
      name: '厂区四A区',
      type: '五醒跑马灯',
      status: 'online',
      category: 'lighting4',
      zone: '厂区四',
      lastActive: ''
    },
    {
      id: 8,
      name: '厂区四B区',
      type: '五醒跑马灯',
      status: 'online',
      category: 'weighing',
      zone: '厂区四',
      lastActive: ''
    },
  ];

  @State selectedCategory: string = '全部';
  @State categories: string[] = ['全部', '厂区一', '厂区二', '厂区三', '厂区四'];
  @State connectionStatus: string = '远程准备就绪';
  @State onlineDevices: number = 4;

  aboutToAppear() {
    this.updateDeviceStats();
  }

  private updateDeviceStats() {
    const filteredDevices = this.getFilteredDevices();
    this.onlineDevices = filteredDevices.filter(device => device.status === 'online').length;
  }

  private getFilteredDevices(): Device[] {
    if (this.selectedCategory === '全部') {
      return this.devices;
    }
    // 根据选择的厂区过滤设备
    return this.devices.filter(device => device.zone === this.selectedCategory);
  }

  private getDeviceIcon(category: string): Resource {
    const iconMap: Record<string, Resource> = {
      'lighting1': $r('app.media.dengpao'),
      'lighting2': $r('app.media.dengpao'),
      'lighting3': $r('app.media.dengpao'),
      'lighting4': $r('app.media.dengpao'),
      'weighing': $r('app.media.y3'),
      'security': $r('app.media.dengpao'),
      'sensor': $r('app.media.y3')
    };
    return iconMap[category] || $r('app.media.dengpao');
  }

  private getStatusColor(status: string): string {
    const colorMap: Record<string, string> = {
      'online': '#4CAF50',
      'offline': '#F44336',
      'standby': '#FF9800'
    };
    return colorMap[status] || '#CCCCCC';
  }

  private getStatusText(status: string): string {
    const textMap: Record<string, string> = {
      'online': '在线',
      'offline': '离线',
      'standby': '待机'
    };
    return textMap[status] || '未知';
  }

  private getTotalDevicesCount(): number {
    return this.getFilteredDevices().length;
  }

  private getOfflineDevicesCount(): number {
    const filteredDevices = this.getFilteredDevices();
    return filteredDevices.filter(device => device.status === 'offline').length;
  }

  build() {
    Column() {
      this.buildHeader()
      this.buildConnectionStatus()
      this.buildCategoryFilter()
      this.buildDeviceStats()
      this.buildDeviceList()
      this.buildBottomStatus()
    }
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({width:'100%',height:'700'})
    .width('100%')
    .height('100%')
  }

  @Builder
  buildHeader() {
    Row() {
      Button() {
        Image($r('app.media.a'))
          .width(24)
          .height(24)
          .fillColor('#333333')
      }
      .width(40)
      .height(40)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
      .border({ width: 1, color: '#E5E5E5' })
      .onClick(() => {
        router.back();
      })

      Text('远程操控')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Button() {
        Image($r('app.media.n'))
          .width(24)
          .height(24)
          .fillColor('#333333')
      }
      .width(40)
      .height(40)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)
      .border({ width: 1, color: '#E5E5E5' })
      .onClick(() => {
        router.push({ url: 'pages/lianjie' });
      })
    }
    .width('100%')
    .height(60)
    .padding({ left: 20, right: 20, top: 10, bottom: 10 })
    .border({ width: { bottom: 1 }, color: '#F0F0F0' })
  }

  @Builder
  buildConnectionStatus() {
    Row() {
      Circle({ width: 8, height: 8 })
        .fill('#2196F3')
        .margin({ right: 8 })

      Text('网络连接正常')
        .fontSize(14)
        .fontColor('#2196F3')
        .fontWeight(FontWeight.Medium)

      Blank()

      Text('信号强度: 优秀')
        .fontSize(12)
        .fontColor('#666666')
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 15, bottom: 15 })
    .backgroundColor('#deeff9')
    .border({ width: { bottom: 1 }, color: '#E8F5E8' })
  }

  @Builder
  buildCategoryFilter() {
    Column() {
      Row() {
        Text('设备分类')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')

        Blank()

        Text(`${this.getTotalDevicesCount()} 台设备`)
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .margin({ bottom: 15 })

      Scroll() {
        Row() {
          ForEach(this.categories, (category: string, index?: number) => {
            Button(category)
              .fontSize(14)
              .fontColor(this.selectedCategory === category ? '#FFFFFF' : '#666666')
              .backgroundColor(this.selectedCategory === category ? '#2196F3' : '#FFFFFF')
              .border({
                width: 1,
                color: this.selectedCategory === category ? '#2196F3' : '#E5E5E5'
              })
              .borderRadius(20)
              .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              .margin({ right: 10 })
              .onClick(() => {
                this.selectedCategory = category;
                // 更新统计数据
                this.updateDeviceStats();
              })
          })
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 20, bottom: 15 })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildDeviceStats() {
    Row() {
      this.buildStatCard('在线设备', this.onlineDevices.toString(), '#2196F3')
      this.buildStatCard('总设备', this.getTotalDevicesCount().toString(), '#112079')
      this.buildStatCard('离线设备', this.getOfflineDevicesCount().toString(), '#F44336')
    }
    .width('100%')
    .padding({ left: 20, right: 20, bottom: 20 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  buildStatCard(title: string, value: string, color: string) {
    Column() {
      Text(value)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
        .margin({ bottom: 4 })

      Text(title)
        .fontSize(12)
        .fontColor('#666666')
    }
    .width(100)
    .height(70)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .border({ width: 1, color: '#E5E5E5' })
    .padding(10)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildDeviceList() {
    Scroll() {
      Column() {
        ForEach(this.getFilteredDevices(), (device: Device, index?: number) => {
          this.buildDeviceCard(device)
        })
      }
      .width('100%')
    }
    .layoutWeight(1)
    .padding({ left: 20, right: 20 })
  }

  @Builder
  buildDeviceCard(device: Device) {
    Row() {
      // 设备图标
      Column() {
        Image(this.getDeviceIcon(device.category))
          .width(40)
          .height(40)
          .fillColor('#666666')
      }
      .width(60)
      .height(60)
      .backgroundColor('#F8F9FA')
      .borderRadius(12)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 设备信息
      Column() {
        Text(device.name)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ bottom: 4 })

        Text(device.type)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ bottom: 6 })

        Row() {
          Circle({ width: 6, height: 6 })
            .fill(this.getStatusColor(device.status))
            .margin({ right: 6 })

          Text(this.getStatusText(device.status))
            .fontSize(11)
            .fontColor(this.getStatusColor(device.status))
        }
      }
      .layoutWeight(1)
      .padding({ left: 15 })
      .alignItems(HorizontalAlign.Start)

      // 操作按钮
      Toggle({ type: ToggleType.Switch,isOn:false })
        .width(60)
        .height(25)
        .onChange((isON)=>{
          if (isON) {
            this.getHttpData1()
          }else {
            this.getHttpData2()
          }
        })
    }
    .width('100%')
    .height(90)
    .padding(15)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .border({ width: 1, color: '#E5E5E5' })
    .margin({ bottom: 12 })
    .shadow({
      radius: 4,
      color: 'rgba(0, 0, 0, 0.08)',
      offsetX: 0,
      offsetY: 2
    })
  }

  @Builder
  buildBottomStatus() {
    Row() {
      Circle({ width: 8, height: 8 })
        .fill('#2196F3')
        .margin({ right: 8 })

      Text(this.connectionStatus)
        .fontSize(14)
        .fontColor('#666666')
        .fontWeight(FontWeight.Medium)

      Blank()

      Text('最后更新: 刚刚')
        .fontSize(12)
        .fontColor('#999999')
    }
    .width('100%')
    .height(50)
    .padding({ left: 20, right: 20 })
    .backgroundColor('#FFFFFF')
    .border({ width: { top: 1 }, color: '#F0F0F0' })
  }

  private controlDevice(device: Device): void {
    if (device.status !== 'online') {
      promptAction.showToast({
        message: '设备不在线，无法控制',
        duration: 2000
      });
      return;
    }

    const routeMap: Record<string, string> = {
      'lighting1': 'pages/yuancheng',
      'lighting2': 'pages/yuancheng1',
      'lighting3': 'pages/yuancheng2',
      'lighting4': 'pages/yuancheng3',
      'weighing': 'pages/shebei3',
      'security': 'pages/shebei3',
      'sensor': 'pages/shebei3'
    };

    const targetPage = routeMap[device.category];
    if (targetPage) {
      try {
        router.push({
          url: targetPage,
          params: { deviceInfo: device }
        });
      } catch (error) {
        promptAction.showToast({
          message: '页面跳转失败',
          duration: 2000
        });
      }
    } else {
      promptAction.showToast({
        message: `正在连接${device.name}...`,
        duration: 2000
      });
    }
  }
  request_url: string = "https://f295448f02.st1.iotda-app.cn-north-4.myhuaweicloud.com:443/v5/iot/d24348add5cb45a0a63eee56364545a0/devices/671ef76965629b34009b20f9_Lamp01/commands"
  getHttpData1() {//进行网络请求
    //let request_url = this.request_url + "?type=" + type + "&key=562022ac0428bb47dacfca9f70260148"
    let request_url = this.request_url
    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header) => {

      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(request_url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': "application/json; charset=UTF-8",
        'X-Auth-Token': token
      },

      extraData: {
        "service_id": "SmartLamp",
        "command_name": "SetLampStatus",
        "paras": { "LampStatus": "ON" }
      },

      connectTimeout: 60000, // 可选，默认为60s
      readTimeout: 60000, // 可选，默认为60s
    },
      (err, data) => {
        if (!err) {
          // data.result为http响应内容，可根据业务需要进行解析
          console.info('Result:' + data.result);
          console.info('code:' + data.responseCode);
          // data.header为http响应头，可根据业务需要进行解析
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + data.cookies); // 8+
          //this.parseData(data.result)

          console.log(JSON.parse(data.result.toString()));


          this.message = data.result.toString()
          //
        } else {
          console.info('error:' + JSON.stringify(err));
          // 当该请求使用完毕时，调用destroy方法主动销毁。
          httpRequest.destroy();
        }
      }

    )
  }
  getHttpData2() {//进行网络请求
    //let request_url = this.request_url + "?type=" + type + "&key=562022ac0428bb47dacfca9f70260148"
    let request_url = this.request_url
    let httpRequest = http.createHttp()
    httpRequest.on('headersReceive', (header) => {

      console.info('header: ' + JSON.stringify(header));
    });
    httpRequest.request(request_url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': "application/json; charset=UTF-8",
        'X-Auth-Token': token
      },

      extraData: {
        "service_id": "SmartLamp",
        "command_name": "SetLampStatus",
        "paras": { "LampStatus": "OFF" }
      },

      connectTimeout: 60000, // 可选，默认为60s
      readTimeout: 60000, // 可选，默认为60s
    },
      (err, data) => {
        if (!err) {
          // data.result为http响应内容，可根据业务需要进行解析
          console.info('Result:' + data.result);
          console.info('code:' + data.responseCode);
          // data.header为http响应头，可根据业务需要进行解析
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + data.cookies); // 8+
          //this.parseData(data.result)

          console.log(JSON.parse(data.result.toString()));


          this.message = data.result.toString()
          //
        } else {
          console.info('error:' + JSON.stringify(err));
          // 当该请求使用完毕时，调用destroy方法主动销毁。
          httpRequest.destroy();
        }
      }

    )
  }
}