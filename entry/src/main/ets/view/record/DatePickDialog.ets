import { CommonConstants } from '../../common/constants/CommonConstants'

@CustomDialog
export default  struct DatePickDialog {
  controller: CustomDialogController
  selectedDate: Date = new Date()

  build() {
    Column() {
      //1.日期选择
      DatePicker({
        start: new Date('1970-1-1'),
        end: new Date(),
        selected: this.selectedDate
      })
        .onChange((value: DatePickerResult) =>
        this.selectedDate.setFullYear(value.year, value.month, value.day))
      //2.按钮
      Row({space:CommonConstants.SPACE_12}){
        Button('取消')
          .width(120)
          .backgroundColor($r('app.color.light_gray'))
          .onClick(()=>this.controller.close())
        Button('确定')
          .width(120)
          .backgroundColor($r('app.color.primary_color'))
          .onClick(()=>{
            //1.将日期保存到全局存储
            AppStorage.SetOrCreate('selectedDate',this.selectedDate.getTime())
            //2.关闭窗口
            this.controller.close()
          })
      }
    }
    .padding(CommonConstants.SPACE_12)
  }
}