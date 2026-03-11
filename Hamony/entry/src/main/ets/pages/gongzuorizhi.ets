import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct gongzuorizhi {
  @State workContent: string = '';
  @State selectedDate: string = '';
  @State currentTime: string = '';

  aboutToAppear() {
    this.updateTime()
    this.updateDate()
    setInterval(() => {
      this.updateTime()
    }, 1000)
  }

  updateTime() {
    const now = new Date()
    const hours = now.getHours().toString().padStart(2, '0')
    const minutes = now.getMinutes().toString().padStart(2, '0')
    this.currentTime = `${hours}:${minutes}`
  }

  updateDate() {
    const now = new Date()
    const year = now.getFullYear()
    const month = (now.getMonth() + 1).toString().padStart(2, '0')
    const day = now.getDate().toString().padStart(2, '0')
    this.selectedDate = `${year}-${month}-${day}`
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
        Row() {
          Button('<')
            .width(60)
            .height(36)
            .fontSize(18)
            .fontColor('#1A1A1A')
            .backgroundColor('rgba(255, 255, 255, 0.8)')
            .borderRadius(18)
            .onClick(() => {
              router.back()
            })

          Text('工作日志')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontColor('#1A1A1A')

          Text(this.currentTime)
            .fontSize(12)
            .fontColor('#666666')
            .backgroundColor('rgba(255, 255, 255, 0.8)')
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .borderRadius(10)
        }
        .width('100%')
        .height(60)
        .padding({ left: 20, right: 20, top: 10 })

        // 主体内容
        Scroll() {
          Column() {
            // 日期选择器
            this.buildDateSection()

            // 工作内容输入
            this.buildWorkContentSection()

            // 提交按钮
            this.buildSubmitSection()

            // 最近日志
            this.buildRecentLogs()
          }
          .padding({ left: 20, right: 20, bottom: 30 })
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
  buildDateSection() {
    Column() {
      Text('工作日期')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 12 })

      Row() {
        Text('📅')
          .fontSize(20)
          .margin({ right: 12 })

        Text(this.selectedDate)
          .fontSize(16)
          .fontColor('#1A1A1A')
          .layoutWeight(1)

        Text('今天')
          .fontSize(14)
          .fontColor('#007AFF')
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .backgroundColor('rgba(0, 122, 255, 0.1)')
          .borderRadius(12)
          .onClick(() => {
            this.updateDate()
          })
      }
      .width('100%')
      .height(50)
      .padding({ left: 16, right: 16 })
      .backgroundColor('rgba(255, 255, 255, 0.6)')
      .borderRadius(12)
      .border({
        width: 1,
        color: 'rgba(0, 0, 0, 0.1)'
      })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .margin({ top: 20, bottom: 25 })
  }

  @Builder
  buildWorkContentSection() {
    Column() {
      Row() {
        Text('工作内容')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')

        Text('*')
          .fontSize(16)
          .fontColor('#FF3B30')
          .margin({ left: 4 })

        Blank()

        Text(`${this.workContent.length}/500`)
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('100%')
      .margin({ bottom: 12 })

      TextArea({
        placeholder: '请详细记录今天的工作内容...\n\n例如：\n• 完成了项目需求分析\n• 参加了团队会议\n• 修复了系统bug\n• 编写了技术文档',
        text: this.workContent
      })
        .fontSize(14)
        .fontColor('#1A1A1A')
        .placeholderColor('#999999')
        .backgroundColor('rgba(255, 255, 255, 0.6)')
        .height(200)
        .borderRadius(12)
        .border({
          width: 1,
          color: 'rgba(0, 0, 0, 0.1)'
        })
        .padding(16)
        .onChange((value: string) => {
          if (value.length <= 500) {
            this.workContent = value;
          }
        })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .margin({ bottom: 25 })
  }

  @Builder
  buildSubmitSection() {
    Column({ space: 12 }) {
      Button(this.canSubmit() ? '提交日志' : '请填写工作内容')
        .width('100%')
        .height(52)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.canSubmit() ? '#007AFF' : '#CCCCCC')
        .fontColor(Color.White)
        .borderRadius(26)
        .enabled(this.canSubmit())
        .onClick(() => {
          this.submitLog()
        })

      Row() {
        Text('💡')
          .fontSize(14)
          .margin({ right: 6 })

        Text('记录工作有助于提高效率和自我管理')
          .fontSize(12)
          .fontColor('#666666')
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .margin({ bottom: 25 })
  }

  @Builder
  buildRecentLogs() {

  }

  @Builder
  buildLogItem(date: string, content: string) {
    Row() {
      Text('📄')
        .fontSize(16)
        .margin({ right: 12 })

      Column() {
        Text(date)
          .fontSize(12)
          .fontColor('#666666')
          .width('100%')
          .margin({ bottom: 4 })

        Text(content)
          .fontSize(14)
          .fontColor('#1A1A1A')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('rgba(255, 255, 255, 0.4)')
    .borderRadius(12)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.05)'
    })
    .margin({ bottom: 8 })
  }

  private canSubmit(): boolean {
    return this.workContent.trim().length > 0;
  }

  private submitLog() {
    if (!this.canSubmit()) {
      return;
    }

    promptAction.showToast({
      message: '工作日志提交成功',
      duration: 2000
    });

    // 清空表单
    this.workContent = '';
  }
}