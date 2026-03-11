import { webview } from '@kit.ArkWeb';
import { titleComponent } from '../component/titleComponent';
import { router } from '@kit.ArkUI';

interface params{
  item:Monitor
}
class Monitor{
  name: string = ''
  status: boolean = false
  direction: string = ''
  sort: string = ''

  constructor(name: string,status: boolean,direction: string,sort: string) {
    this.name = name
    this.status = status
    this.direction = direction
    this.sort = sort
  }
}
@Entry
@Component
struct Page1 {
  @State message: string = 'Hello World';
  @State webcontroller: WebviewController = new webview.WebviewController
  @State data: Monitor = new Monitor('',false,'','')

  aboutToAppear(): void {
    let paramsData = router.getParams() as params
    this.data = paramsData.item
  }

  build() {
    Column() {
      titleComponent({name: this.data.name+' —— '+ this.data.direction}).margin({bottom:10})
      Web({src:'http://192.168.31.30:5000/video_feed',controller: this.webcontroller})
        .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
}