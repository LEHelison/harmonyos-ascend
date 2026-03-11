import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export default struct yonghu2 {
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
            .fontSize(14)
            .fontColor('#1A1A1A')
            .backgroundColor('rgba(255, 255, 255, 0.8)')
            .borderRadius(18)
            .onClick(() => {
              router.back()
            })

          Text('设置')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontColor('#1A1A1A')

          Button('保存')
            .width(60)
            .height(36)
            .fontSize(14)
            .fontColor('#1A1A1A')
            .backgroundColor('rgba(255, 255, 255, 0.8)')
            .borderRadius(18)
            .onClick(() => {
              promptAction.showToast({
                message: '设置已保存',
                duration: 1500
              })
            })
        }
        .width('100%')
        .height(60)
        .padding({ left: 20, right: 20, top: 10 })

        // 主体内容
        Scroll() {
          Column() {
            // 用户信息区域
            this.buildUserSection()

            // 设置选项列表
            this.buildSettingsList()
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
  buildUserSection() {

  }

  @Builder
  buildSettingsList() {
    Column() {
      this.buildSettingItem('', '修改用户信息', () => {
        promptAction.showToast({
          message: '修改用户信息',
          duration: 1500
        })
      })

      this.buildSettingItem('', '用户权限查看', () => {
        promptAction.showToast({
          message: '用户权限查看',
          duration: 1500
        })
      })

      this.buildSettingItem('️', '密钥管理', () => {
        promptAction.showToast({
          message: '密钥管理',
          duration: 1500
        })
      })

      this.buildSettingItem('', '密码修改', () => {
        promptAction.showToast({
          message: '密码修改',
          duration: 1500
        })
      })

      this.buildSettingItem('', '注销账号', () => {
        AlertDialog.show({
          title: '确认注销',
          message: '注销后将清除所有数据，确定要注销账号吗？',
          primaryButton: {
            value: '确定注销',
            fontColor: '#FF3B30',
            action: () => {
              promptAction.showToast({
                message: '账号已注销',
                duration: 2000
              })
            }
          },
          secondaryButton: {
            value: '取消',
            action: () => {}
          }
        })
      }, '#FF3B30')

      this.buildSettingItem('', '版本号 1.0.01', () => {
        promptAction.showToast({
          message: '当前版本: 1.0.01',
          duration: 1500
        })
      })
    }
    .width('100%')
  }

  @Builder
  buildSettingItem(icon: string, title: string, action: () => void, textColor?: string) {
    Row() {
      Text(icon)
        .fontSize(20)
        .margin({ right: 16 })

      Text(title)
        .fontSize(16)
        .fontColor(textColor || '#1A1A1A')
        .layoutWeight(1)

      Text('>')
        .fontSize(16)
        .fontColor('#CCCCCC')
    }
    .width('100%')
    .height(56)
    .padding({ left: 20, right: 20 })
    .backgroundColor('rgba(255, 255, 255, 0.8)')
    .backdropBlur(20)
    .borderRadius(16)
    .border({
      width: 1,
      color: 'rgba(0, 0, 0, 0.1)'
    })
    .margin({ bottom: 12 })
    .onClick(action)
  }
}