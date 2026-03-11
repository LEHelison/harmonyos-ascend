import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct tousu {
  @State complaintObject: string = '';
  @State complaintContent: string = '';
  @State selectedType: string = '服务质量';
  @State isSubmitting: boolean = false;

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

        // 主体内容
        Scroll() {
          Column() {
            // 页面标题
            this.buildPageTitle()

            // 投诉类型选择
            this.buildComplaintType()

            // 投诉对象输入
            this.buildComplaintObject()

            // 投诉内容输入
            this.buildComplaintContent()

            // 提交按钮
            this.buildSubmitButton()

            // 帮助提示
            this.buildHelpTips()
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
  buildHeader() {
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

      Text('投诉中心')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .fontColor('#1A1A1A')

      Button('帮助')
        .width(50)
        .height(36)
        .fontSize(14)
        .fontColor('#1A1A1A')
        .backgroundColor('rgba(255, 255, 255, 0.8)')
        .borderRadius(18)
        .onClick(() => {
          promptAction.showToast({
            message: '帮助功能',
            duration: 1500
          })
        })
    }
    .width('100%')
    .height(60)
    .padding({ left: 20, right: 20, top: 10 })
  }

  @Builder
  buildPageTitle() {
    Column() {
      Text('意见反馈')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .margin({ bottom: 8 })

      Text('您的每一条反馈都是我们改进的动力')
        .fontSize(14)
        .fontColor('#666666')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .padding({ top: 20, bottom: 30 })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildComplaintType() {
    Column() {
      Row() {
        Text('投诉类型')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')

        Text('*')
          .fontSize(16)
          .fontColor('#FF3B30')
          .margin({ left: 4 })
      }
      .width('100%')
      .margin({ bottom: 12 })

      Row() {
        this.buildTypeChip('服务质量')
        this.buildTypeChip('设备故障')
        this.buildTypeChip('系统问题')
        this.buildTypeChip('其他')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
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
    .margin({ bottom: 20 })
  }

  @Builder
  buildTypeChip(type: string) {
    Text(type)
      .fontSize(12)
      .fontColor(this.selectedType === type ? Color.White : '#1A1A1A')
      .backgroundColor(this.selectedType === type ? '#007AFF' : 'rgba(255, 255, 255, 0.8)')
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .borderRadius(16)
      .border({
        width: 1,
        color: this.selectedType === type ? '#007AFF' : 'rgba(0, 0, 0, 0.1)'
      })
      .onClick(() => {
        this.selectedType = type;
      })
  }

  @Builder
  buildComplaintObject() {
    Column() {
      Row() {
        Text('投诉对象')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')

        Text('*')
          .fontSize(16)
          .fontColor('#FF3B30')
          .margin({ left: 4 })
      }
      .width('100%')
      .margin({ bottom: 12 })

      TextInput({
        placeholder: '请输入投诉对象（如：设备名称、服务人员等）',
        text: this.complaintObject
      })
        .fontSize(14)
        .fontColor('#1A1A1A')
        .placeholderColor('#999999')
        .backgroundColor('rgba(255, 255, 255, 0.6)')
        .height(50)
        .borderRadius(12)
        .border({
          width: 1,
          color: 'rgba(0, 0, 0, 0.1)'
        })
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => {
          this.complaintObject = value;
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
    .margin({ bottom: 20 })
  }

  @Builder
  buildComplaintContent() {
    Column() {
      Row() {
        Text('投诉内容')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1A1A1A')

        Text('*')
          .fontSize(16)
          .fontColor('#FF3B30')
          .margin({ left: 4 })

        Blank()

        Text(`${this.complaintContent.length}/500`)
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('100%')
      .margin({ bottom: 12 })

      TextArea({
        placeholder: '请详细描述您遇到的问题，我们将认真处理您的反馈...',
        text: this.complaintContent
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
            this.complaintContent = value;
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
  buildSubmitButton() {
    Column({ space: 12 }) {
      Button(this.isSubmitting ? '提交中...' : '📝 提交投诉')
        .width('100%')
        .height(52)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.canSubmit() && !this.isSubmitting ? '#007AFF' : '#CCCCCC')
        .fontColor(Color.White)
        .borderRadius(26)
        .enabled(this.canSubmit() && !this.isSubmitting)
        .onClick(() => {
          this.submitComplaint();
        })

      if (this.isSubmitting) {
        Row() {
          LoadingProgress()
            .width(20)
            .height(20)
            .color('#007AFF')
            .margin({ right: 8 })

          Text('正在提交您的反馈...')
            .fontSize(14)
            .fontColor('#666666')
        }
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .margin({ bottom: 25 })
  }

  @Builder
  buildHelpTips() {
    Column() {
      Text('💡 温馨提示')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('100%')
        .margin({ bottom: 12 })

      Column() {
        this.buildTipItem('请如实填写相关信息，以便我们更好地处理')
        this.buildTipItem('我们将在24小时内回复您的投诉')
        this.buildTipItem('您可以在"我的投诉"中查看处理进度')
        this.buildTipItem('紧急问题请直接联系客服热线：400-1234-567')
      }
      .width('100%')
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
  }

  @Builder
  buildTipItem(content: string) {
    Row() {
      Text('•')
        .fontSize(14)
        .fontColor('#007AFF')
        .margin({ right: 8 })

      Text(content)
        .fontSize(12)
        .fontColor('#666666')
        .layoutWeight(1)
    }
    .width('100%')
    .margin({ bottom: 8 })
  }

  private canSubmit(): boolean {
    return this.complaintObject.trim().length > 0 &&
      this.complaintContent.trim().length > 0;
  }

  private submitComplaint() {
    if (!this.canSubmit()) {
      promptAction.showToast({
        message: '请填写完整信息',
        duration: 2000
      });
      return;
    }

    this.isSubmitting = true;

    // 模拟提交过程
    setTimeout(() => {
      this.isSubmitting = false;

      promptAction.showToast({
        message: '投诉已提交成功，我们将尽快处理',
        duration: 3000
      });

      // 清空表单
      this.complaintObject = '';
      this.complaintContent = '';
      this.selectedType = '服务质量';

      // 可以选择返回上一页
      setTimeout(() => {
        router.back();
      }, 1500);
    }, 2000);
  }
}