import { titleComponent } from '../component/titleComponent';
import { router } from '@kit.ArkUI';


@Entry
@Component
struct MonitorPage {
  @State monitors: Monitor[] = [
    new Monitor('厂房一车间正门',true,'车间正门','厂房一'),
    new Monitor('厂房二车间东门',true,'车间东门','厂房二'),
    new Monitor('厂房一车间东南角',false,'车间东南角','厂房一'),
    new Monitor('厂房一车间西北角',true,'车间西北角','厂房一'),
    new Monitor('厂房三车间南门',true,'车间南门','厂房三'),
    new Monitor('厂房三车间南门',true,'车间南门','厂房三'),
    new Monitor('厂房三车间南门',true,'车间南门','厂房三'),
    new Monitor('厂房三车间南门',true,'车间南门','厂房三'),
    new Monitor('厂房三车间南门',true,'车间南门','厂房三'),
    new Monitor('厂房三车间南门',true,'车间南门','厂房三'),
    new Monitor('厂房三车间南门',true,'车间南门','厂房三'),

  ]
  @State SearchMonitors: Monitor[] = [];
  @State selectedFilter: string = '全部';
  @State selectedMonitors: Monitor[] = [];
  @State isSousuo: boolean = false
  tabsList: string[] = ['全部','厂房一','厂房二','厂房三','厂房四']

  search: string = ''
  text: string = ''
  tabController: TabsController = new TabsController()

  aboutToAppear(): void {
    this.selectedMonitors = this.monitors
  }




  build() {
    Column() {
      titleComponent({name:'车间监测'}).margin({bottom:20})
      Row(){
        Image($r('app.media.search'))
          .width(20)
          .margin({left:15,right:10})
        TextInput({placeholder:'请输入要查看的摄像头',text: $$this.text})
          .placeholderFont({size:14})
          .width('70%')
          .borderRadius(0)
          .backgroundColor('#0000')
          .borderWidth({left:1,right:1})
          .onTouch(() => {
            this.isSousuo = true
          })
          .onBlur(() => {
            this.isSousuo = false
          })
          .onChange(() => {
            if (this.search !== this.text) {
              this.SearchMonitors = []
              this.search = this.text

              for (let index = 0; index < this.monitors.length; index++) {
                if (this.monitors[index].name.includes(this.search)) {
                  this.SearchMonitors.push(this.monitors[index])
                }
              }
              if (this.search == '') {
                this.SearchMonitors = []
              }
            }
          })
        Button('搜索')
          .backgroundColor('#0000')
          .fontColor(Color.Black)
          .fontSize(16)
          .padding(11)
          .stateEffect(false)
          .onClick(() => {
            this.selectedMonitors = this.SearchMonitors
            this.isSousuo = false

          })
      }
      .width('90%')
      .height(40)
      .borderRadius(20)
      .borderWidth(1)
      .backgroundColor('#002377fd')






      Stack(){
        Row(){
          this.buildSearchAndFilter()
          this.content()
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .layoutWeight(1)
        .margin({top: 20})


        if (this.isSousuo){
          Column(){
            ForEach(this.SearchMonitors,(item: Monitor,index: number) => {
              Row(){
                Text(item.name)
                Blank()
                Row(){
                  Circle({ width: 10, height: 10 })
                    .fill(item.status ? Color.Green : Color.Red)
                    .margin({ right: 8 })
                  Text(item.status ? '在线' : '离线')
                    .fontSize(12)
                    .fontColor(item.status ? '#1A1A1A': '#681a1a1a')
                }
              }
              .width('100%')
              .padding(7)
              .borderWidth({bottom: 1})
              .borderColor('rgba(0, 0, 0, 0.1)')
              .width('100%')
              .backgroundColor(Color.White)
              .onClick(() => {
                if (item.status) {
                  router.pushUrl({
                    url: 'pages/monitor',
                    params:{
                      item: item
                    }
                  })
                }
              })

            })
          }
          .width('62%')
          .borderWidth(1)
          .borderColor('rgba(0, 0, 0, 0.1)')
        }


      }
      .alignContent(Alignment.Top)
      .layoutWeight(1)

    }
    .width('100%')
    .height('104%')
    .expandSafeArea([SafeAreaType.SYSTEM])
    .backgroundImage($r("app.media.img"))
    .backgroundImageSize({width:'100%',height:'100%'})
  }

  @Builder
  buildSearchAndFilter() {
    Scroll() {
      // 状态筛选
      Column() {
        ForEach(this.tabsList,(item: string,index: number) => {
          this.buildFilterChip(item)
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('25%')
    .padding({ left: 10, right: 10 })
    .margin({ bottom: 15 })
  }

  @Builder
  buildFilterChip(status: string) {
    Text(status)
      .textAlign(TextAlign.Center)
      .fontSize(15)
      .fontColor(this.selectedFilter === status ? Color.White : '#1A1A1A')
      .backgroundColor(this.selectedFilter === status ? '#007AFF' : 'rgba(255, 255, 255, 0.8)')
      .backdropBlur(10)
      .width('100%')
      .height('20%')
      .padding({ left: 10, right: 10, top: 35, bottom: 35 })
      .borderRadius(5)
      .border({
        width: 1,
        color: this.selectedFilter === status ? '#007AFF' : 'rgba(0, 0, 0, 0.1)'
      })
      .onClick(() => {
        this.filterByStatus(status);
      })
  }

  //重新排列数组
  private filterByStatus(status: string) {
    this.selectedFilter = status;
    if (status === '全部') {
      this.selectedMonitors = this.monitors;
    } else {
      this.selectedMonitors = this.monitors.filter(item => item.sort === status);
    }
  }


  @Builder
  content(){
    Scroll(){
      Column(){
        ForEach(this.selectedMonitors,(item: Monitor,index: number) => {
          Column(){
            Row(){
              Column({space:7}){
                Circle({ width: 10, height: 10 })
                  .fill(item.status ? Color.Green : Color.Red)
                  .margin({ right: 8 })
                Text(item.status ? '在线' : '离线')
                  .fontSize(12)
                  .fontColor(item.status ? '#1A1A1A': '#681a1a1a')
              }
              Column(){
                Text(item.name)
                  .fontSize(15)
                  .width('50%')
                  .fontColor(item.status ? '#1A1A1A': '#681a1a1a')

              }


              Row({space:5}){
                Image($r('app.media.monitor'))
                  .width(22)
                  .fillColor(item.status ? Color.Green : Color.Red)
                Text('>')
                  .fontSize(20)
                  .fontColor('#1A1A1A')
                  .fontColor(item.status ? '#1A1A1A': '#681a1a1a')
              }
            }
            .padding(13)
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)


          }
          .justifyContent(FlexAlign.Center)
          .height(84)
          .borderRadius(20)
          .border({
            width: 1,
            color: 'rgba(0, 0, 0, 0.1)'
          })
          .backgroundColor(Color.White)

          .onClick(() => {
            if (item.status) {
              router.pushUrl({
                url: 'pages/monitor',
                params:{
                  item: item
                }
              })
            }
          })
        })
      }
      .layoutWeight(1)

    }
    .height('100%')
    .width('75%')
    .margin({bottom:15})
  }
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
