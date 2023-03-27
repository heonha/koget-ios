// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum S {
  /// 새로워진 코젯 확인하기
  internal static let adCell = S.tr("Localizable", "ad_cell", fallback: "새로워진 코젯 확인하기")
  /// 앱 버전
  internal static let kogetVersion = S.tr("Localizable", "koget_version", fallback: "앱 버전")
  /// Localizable.strings
  ///   koget
  /// 
  ///   Created by Heonjin Ha on 2023/02/22.
  internal static let unknown = S.tr("Localizable", "unknown", fallback: "알수없음")
  internal enum Alert {
    /// 삭제 확인
    internal static let checkDelete = S.tr("Localizable", "alert.check_delete", fallback: "삭제 확인")
    /// 삭제한 위젯은 잠금화면에서도 변경 또는 삭제 해주세요
    internal static let deleteSuccessSubtitle = S.tr("Localizable", "alert.delete_success_subtitle", fallback: "삭제한 위젯은 잠금화면에서도 변경 또는 삭제 해주세요")
    /// 위젯 삭제 완료!
    internal static let deleteSuccessTitle = S.tr("Localizable", "alert.delete_success_title", fallback: "위젯 삭제 완료!")
    /// 편집된 내용은 15분 내 반영됩니다.
    internal static let editSuccessSubtitle = S.tr("Localizable", "alert.edit_success_subtitle", fallback: "편집된 내용은 15분 내 반영됩니다.")
    /// 위젯 편집 성공
    internal static let editSuccessTitle = S.tr("Localizable", "alert.edit_success_title", fallback: "위젯 편집 성공")
    /// 확인 필요
    internal static let needCheck = S.tr("Localizable", "alert.need_check", fallback: "확인 필요")
    internal enum Message {
      /// 이 위젯을 삭제 할까요?
      internal static let checkWidgetDelete = S.tr("Localizable", "alert.message.check_Widget_Delete", fallback: "이 위젯을 삭제 할까요?")
    }
  }
  internal enum AppRequest {
    /// 앱/웹 이름
    internal static let appName = S.tr("Localizable", "app_request.app_name", fallback: "앱/웹 이름")
    /// 요청할 앱/웹 이름
    internal static let appNamePlaceholder = S.tr("Localizable", "app_request.app_name_placeholder", fallback: "요청할 앱/웹 이름")
    /// 요청하신 앱/웹은 검토 결과에 따라 앱에 추가 될 예정입니다.
    internal static let description = S.tr("Localizable", "app_request.description", fallback: "요청하신 앱/웹은 검토 결과에 따라 앱에 추가 될 예정입니다.")
    /// 보내기
    internal static let send = S.tr("Localizable", "app_request.send", fallback: "보내기")
    /// 내용
    internal static let textBody = S.tr("Localizable", "app_request.text_body", fallback: "내용")
    /// 선택사항
    internal static let textBodyPlaceholder = S.tr("Localizable", "app_request.text_body_placeholder", fallback: "선택사항")
    /// 앱/웹 추가 요청
    internal static let title = S.tr("Localizable", "app_request.title", fallback: "앱/웹 추가 요청")
    internal enum Alert {
      /// 확인 필요
      internal static let needCheck = S.tr("Localizable", "app_request.alert.needCheck", fallback: "확인 필요")
      /// 앱/웹 이름을 기재해주세요.
      internal static let needCheckSubtitle = S.tr("Localizable", "app_request.alert.needCheckSubtitle", fallback: "앱/웹 이름을 기재해주세요.")
      /// 요청 전송 오류
      internal static let requestError = S.tr("Localizable", "app_request.alert.requestError", fallback: "요청 전송 오류")
      /// 요청실패. 네트워크 또는 서버 오류.
      internal static let requestErrorSubtitle = S.tr("Localizable", "app_request.alert.requestErrorSubtitle", fallback: "요청실패. 네트워크 또는 서버 오류.")
      /// 앱/웹 추가요청 성공
      internal static let success = S.tr("Localizable", "app_request.alert.success", fallback: "앱/웹 추가요청 성공")
      /// 빠르게 요청에 보답하겠습니다.
      internal static let successSubtitle = S.tr("Localizable", "app_request.alert.successSubtitle", fallback: "빠르게 요청에 보답하겠습니다.")
    }
  }
  internal enum Button {
    /// 취소
    internal static let cancel = S.tr("Localizable", "button.cancel", fallback: "취소")
    /// 투명도 조절
    internal static let changeOpacity = S.tr("Localizable", "button.change_opacity", fallback: "투명도 조절")
    /// 닫기
    internal static let close = S.tr("Localizable", "button.close", fallback: "닫기")
    /// 삭제
    internal static let delete = S.tr("Localizable", "button.delete", fallback: "삭제")
    /// 편집
    internal static let edit = S.tr("Localizable", "button.edit", fallback: "편집")
    /// 완료
    internal static let finish = S.tr("Localizable", "button.finish", fallback: "완료")
    /// 뒤로가기
    internal static let goBack = S.tr("Localizable", "button.go_back", fallback: "뒤로가기")
    /// 실행하기
    internal static let run = S.tr("Localizable", "button.run", fallback: "실행하기")
    /// 저장
    internal static let save = S.tr("Localizable", "button.save", fallback: "저장")
    /// 테스트
    internal static let test = S.tr("Localizable", "button.test", fallback: "테스트")
  }
  internal enum ContactType {
    /// 기타 문의사항
    internal static let etc = S.tr("Localizable", "contact_type.etc", fallback: "기타 문의사항")
    /// 피드백 보내기
    internal static let feedback = S.tr("Localizable", "contact_type.feedback", fallback: "피드백 보내기")
    /// 앱 관련 문제
    internal static let problemApp = S.tr("Localizable", "contact_type.problem_app", fallback: "앱 관련 문제")
    /// 앱 추가요청
    internal static let requestApp = S.tr("Localizable", "contact_type.request_app", fallback: "앱 추가요청")
    /// 선택하세요
    internal static let select = S.tr("Localizable", "contact_type.select", fallback: "선택하세요")
  }
  internal enum ContactView {
    /// 문의를 보낼까요?
    internal static let canYouSendContact = S.tr("Localizable", "contact_view.can_you_send_contact", fallback: "문의를 보낼까요?")
    /// 내용 확인
    internal static let checkContents = S.tr("Localizable", "contact_view.check_contents", fallback: "내용 확인")
    /// 문의하기
    internal static let contact = S.tr("Localizable", "contact_view.contact", fallback: "문의하기")
    /// * 문의 내용에 개인정보를 입력하지 마세요.
    internal static let description1 = S.tr("Localizable", "contact_view.description1", fallback: "* 문의 내용에 개인정보를 입력하지 마세요.")
    /// * 문의는 익명으로 발송됩니다.
    internal static let description2 = S.tr("Localizable", "contact_view.description2", fallback: "* 문의는 익명으로 발송됩니다.")
    /// * 문의 내용은 앱 서비스 개선에 활용됩니다.
    internal static let description3 = S.tr("Localizable", "contact_view.description3", fallback: "* 문의 내용은 앱 서비스 개선에 활용됩니다.")
    /// * 앱 개선을 위하여 기기의 버전정보를 수집합니다.
    internal static let description4 = S.tr("Localizable", "contact_view.description4", fallback: "* 앱 개선을 위하여 기기의 버전정보를 수집합니다.")
    /// 문의 안내사항
    internal static let descriptionTitle = S.tr("Localizable", "contact_view.description_title", fallback: "문의 안내사항")
    /// 보내기
    internal static let send = S.tr("Localizable", "contact_view.send", fallback: "보내기")
    /// 문의 보내기
    internal static let sendContact = S.tr("Localizable", "contact_view.send_contact", fallback: "문의 보내기")
    /// 문의 제목
    internal static let title = S.tr("Localizable", "contact_view.title", fallback: "문의 제목")
    /// 이곳에 문의내용을 입력하세요.
    internal static let titlePlaceholder = S.tr("Localizable", "contact_view.title_placeholder", fallback: "이곳에 문의내용을 입력하세요.")
    /// 문의 유형
    internal static let type = S.tr("Localizable", "contact_view.type", fallback: "문의 유형")
    internal enum Alert {
      /// 확인 필요
      internal static let needCheck = S.tr("Localizable", "contact_view.alert.need_check", fallback: "확인 필요")
      /// 빈칸을 확인해주세요.
      internal static let needCheckSubtitle = S.tr("Localizable", "contact_view.alert.need_check_subtitle", fallback: "빈칸을 확인해주세요.")
      /// 오류 발생
      internal static let requestError = S.tr("Localizable", "contact_view.alert.request_error", fallback: "오류 발생")
      /// 요청실패. 네트워크 또는 서버 오류.
      internal static let requestErrorTitle = S.tr("Localizable", "contact_view.alert.request_error_title", fallback: "요청실패. 네트워크 또는 서버 오류.")
      /// 문의 보내기 성공
      internal static let sendSuccess = S.tr("Localizable", "contact_view.alert.send_success", fallback: "문의 보내기 성공")
      /// 피드백을 보내주셔서 감사합니다.
      internal static let sendSuccessSubtitle = S.tr("Localizable", "contact_view.alert.send_success_subtitle", fallback: "피드백을 보내주셔서 감사합니다.")
    }
  }
  internal enum DetailWidgetView {
    /// 편집 후 실제 위젯에 반영되기까지 약 15분 이내의 시간이 소요됩니다. (iOS 위젯 업데이트시간)
    internal static let bottomText = S.tr("Localizable", "detail_widget_view.bottom_text", fallback: "편집 후 실제 위젯에 반영되기까지 약 15분 이내의 시간이 소요됩니다. (iOS 위젯 업데이트시간)")
  }
  internal enum Error {
    /// 빈칸을 채워주세요.
    internal static let emptyField = S.tr("Localizable", "error.empty_field", fallback: "빈칸을 채워주세요.")
    /// 사진을 추가해주세요.
    internal static let emptyImage = S.tr("Localizable", "error.empty_image", fallback: "사진을 추가해주세요.")
    /// 이름의 최대글자수는 %d자 입니다.
    internal static func nameLetterLimited(_ p1: Int) -> String {
      return S.tr("Localizable", "error.name_letter_limited", p1, fallback: "이름의 최대글자수는 %d자 입니다.")
    }
    /// URL에 문자열 :// 이 반드시 들어가야 합니다.
    internal static let urlSyntax = S.tr("Localizable", "error.url_syntax", fallback: "URL에 문자열 :// 이 반드시 들어가야 합니다.")
  }
  internal enum FloatingButton {
    /// 위젯 만들기
    internal static let makeWidget = S.tr("Localizable", "floating_button.make_widget", fallback: "위젯 만들기")
  }
  internal enum License {
    /// 오픈소스 라이선스
    internal static let title = S.tr("Localizable", "license.title", fallback: "오픈소스 라이선스")
  }
  internal enum LockscreenHelper {
    /// 1. 잠금화면 상태에서 화면을 길게 탭하기.
    internal static let description1 = S.tr("Localizable", "lockscreen_helper.description1", fallback: "1. 잠금화면 상태에서 화면을 길게 탭하기.")
    /// 2. 사용자화 - 잠금화면 - 위젯선택 누르기
    internal static let description2 = S.tr("Localizable", "lockscreen_helper.description2", fallback: "2. 사용자화 - 잠금화면 - 위젯선택 누르기")
    /// 3. 위젯 리스트에서 코젯을 선택
    internal static let description3 = S.tr("Localizable", "lockscreen_helper.description3", fallback: "3. 위젯 리스트에서 코젯을 선택")
    /// 4.'바로가기 위젯추가' 를 누르세요.
    internal static let description4 = S.tr("Localizable", "lockscreen_helper.description4", fallback: "4.'바로가기 위젯추가' 를 누르세요.")
    /// 5.'눌러서 위젯선택'을 눌러 위젯을 선택하세요.
    internal static let description5 = S.tr("Localizable", "lockscreen_helper.description5", fallback: "5.'눌러서 위젯선택'을 눌러 위젯을 선택하세요.")
    /// 6. 우측 상단 '완료' 버튼을 눌러 저장하세요.
    internal static let description6 = S.tr("Localizable", "lockscreen_helper.description6", fallback: "6. 우측 상단 '완료' 버튼을 눌러 저장하세요.")
    /// 잠금화면에 위젯 등록
    internal static let descriptionTitle = S.tr("Localizable", "lockscreen_helper.description_title", fallback: "잠금화면에 위젯 등록")
  }
  internal enum MainWidgetView {
    internal enum EmptyGrid {
      /// 아직 잠금화면 위젯이 없어요.
      internal static let messageLine1 = S.tr("Localizable", "main_widget_view.emptyGrid.message_line1", fallback: "아직 잠금화면 위젯이 없어요.")
      /// 여기를 눌러 바로 시작하세요!
      internal static let messageLine2 = S.tr("Localizable", "main_widget_view.emptyGrid.message_line2", fallback: "여기를 눌러 바로 시작하세요!")
    }
  }
  internal enum MakeWidgetView {
    /// 앱 리스트에서 가져오기
    internal static let fetchAppListLabel = S.tr("Localizable", "make_widget_view.fetch_app_list_label", fallback: "앱 리스트에서 가져오기")
    /// 위젯 만들기
    internal static let navigationTitle = S.tr("Localizable", "make_widget_view.navigation_title", fallback: "위젯 만들기")
    internal enum IsImageError {
      /// 아직 이미지 아이콘이 없어요. 
      /// 기본 이미지로 생성할까요?
      internal static let message = S.tr("Localizable", "make_widget_view.is_image_error.message", fallback: "아직 이미지 아이콘이 없어요. \n기본 이미지로 생성할까요?")
      /// 기본이미지로 생성
      internal static let okButton = S.tr("Localizable", "make_widget_view.is_image_error.ok_button", fallback: "기본이미지로 생성")
      /// 이미지 확인
      internal static let title = S.tr("Localizable", "make_widget_view.is_image_error.title", fallback: "이미지 확인")
    }
  }
  internal enum OpacitySlider {
    /// 잠금화면 위젯의 불투명도입니다.
    internal static let description = S.tr("Localizable", "opacity_slider.description", fallback: "잠금화면 위젯의 불투명도입니다.")
    /// 불투명
    internal static let opacity = S.tr("Localizable", "opacity_slider.opacity", fallback: "불투명")
    /// 투명
    internal static let transparency = S.tr("Localizable", "opacity_slider.transparency", fallback: "투명")
  }
  internal enum PatchnoteList {
    /// 업데이트 소식
    internal static let navigationTitle = S.tr("Localizable", "patchnote_list.navigation_title", fallback: "업데이트 소식")
  }
  internal enum PhotoEditMenu {
    /// 이미지
    /// 선택
    internal static let selectWidget = S.tr("Localizable", "photo_edit_menu.selectWidget", fallback: "이미지\n선택")
  }
  internal enum SettingMenu {
    /// 더보기
    internal static let navigationTitle = S.tr("Localizable", "setting_menu.navigation_title", fallback: "더보기")
    internal enum Section {
      internal enum AboutApp {
        /// 앱에 관하여
        internal static let title = S.tr("Localizable", "setting_menu.section.about_app.title", fallback: "앱에 관하여")
        /// 앱 평가하기
        internal static let voteRate = S.tr("Localizable", "setting_menu.section.about_app.vote_rate", fallback: "앱 평가하기")
      }
      internal enum Communicate {
        /// 문의하기
        internal static let contactUs = S.tr("Localizable", "setting_menu.section.communicate.contact_us", fallback: "문의하기")
        /// 앱 추가요청
        internal static let requestAddApp = S.tr("Localizable", "setting_menu.section.communicate.request_add_app", fallback: "앱 추가요청")
        /// 소통하기
        internal static let title = S.tr("Localizable", "setting_menu.section.communicate.title", fallback: "소통하기")
      }
      internal enum HowToUse {
        /// 잠금화면에 위젯 등록
        internal static let addWidget = S.tr("Localizable", "setting_menu.section.how_to_use.add_widget", fallback: "잠금화면에 위젯 등록")
        /// 사용방법
        internal static let title = S.tr("Localizable", "setting_menu.section.how_to_use.title", fallback: "사용방법")
      }
    }
  }
  internal enum Textfield {
    internal enum Placeholder {
      /// URL - (특수문자 :// 포함)
      internal static let url = S.tr("Localizable", "textfield.placeholder.url", fallback: "URL - (특수문자 :// 포함)")
      /// 위젯 이름
      internal static let widgetName = S.tr("Localizable", "textfield.placeholder.widget_Name", fallback: "위젯 이름")
      /// 예시: youtube://
      internal static let widgetUrlShort = S.tr("Localizable", "textfield.placeholder.widget_url_short", fallback: "예시: youtube://")
    }
  }
  internal enum UrlTestButton {
    /// 입력한 URL을 실행하시겠습니까?
    ///  성공 시 앱 또는 웹 브라우저로 연결됩니다.
    internal static let checkRun = S.tr("Localizable", "url_test_button.check_run", fallback: "입력한 URL을 실행하시겠습니까?\n 성공 시 앱 또는 웹 브라우저로 연결됩니다.")
    /// URL 확인
    internal static let checkUrl = S.tr("Localizable", "url_test_button.check_url", fallback: "URL 확인")
    /// URL에 들어갈 수 없는 글자가 있습니다.
    internal static let checkUrlSubtitleNourl = S.tr("Localizable", "url_test_button.check_url_subtitle_nourl", fallback: "URL에 들어갈 수 없는 글자가 있습니다.")
    /// 문자열 :// 이 반드시 들어가야합니다. 
    /// (앱이름:// 또는 https://주소)
    internal static let checkUrlSubtitleSpecific = S.tr("Localizable", "url_test_button.check_url_subtitle_specific", fallback: "문자열 :// 이 반드시 들어가야합니다. \n(앱이름:// 또는 https://주소)")
    /// 테스트 진행
    internal static let runTest = S.tr("Localizable", "url_test_button.run_test", fallback: "테스트 진행")
    /// URL 테스트
    internal static let testUrl = S.tr("Localizable", "url_test_button.test_url", fallback: "URL 테스트")
  }
  internal enum Widget {
    /// 위젯확인
    internal static let checkWidget = S.tr("Localizable", "widget.check_widget", fallback: "위젯확인")
    /// 바로가기
    /// 위젯추가
    internal static let emptyPlaceholder = S.tr("Localizable", "widget.empty_placeholder", fallback: "바로가기\n위젯추가")
    /// 눌러서
    /// 위젯선택
    internal static let selectWidget = S.tr("Localizable", "widget.select_widget", fallback: "눌러서\n위젯선택")
    internal enum Config {
      /// 아이콘을 눌러 잠금화면에 놓으세요.
      /// 그리고 코젯 앱에서 생성한 위젯을 선택하세요.
      internal static let subtitle = S.tr("Localizable", "widget.config.subtitle", fallback: "아이콘을 눌러 잠금화면에 놓으세요.\n그리고 코젯 앱에서 생성한 위젯을 선택하세요.")
      /// 바로가기 위젯
      internal static let title = S.tr("Localizable", "widget.config.title", fallback: "바로가기 위젯")
    }
  }
  internal enum WidgetAssetList {
    /// 앱 리스트
    internal static let appList = S.tr("Localizable", "widget_asset_list.appList", fallback: "앱 리스트")
    /// 실행가능만 보기
    internal static let excutableToggleLabel = S.tr("Localizable", "widget_asset_list.excutableToggleLabel", fallback: "실행가능만 보기")
    /// (미설치)
    internal static let notInstalled = S.tr("Localizable", "widget_asset_list.not_installed", fallback: "(미설치)")
    /// 앱 추가요청
    internal static let requestApp = S.tr("Localizable", "widget_asset_list.requestApp", fallback: "앱 추가요청")
    /// 앱 검색하기
    internal static let searchApp = S.tr("Localizable", "widget_asset_list.searchApp", fallback: "앱 검색하기")
  }
  internal enum WidgetCell {
    internal enum WidgetType {
      /// 앱
      internal static let app = S.tr("Localizable", "widget_cell.widgetType.app", fallback: "앱")
      /// 웹 페이지
      internal static let web = S.tr("Localizable", "widget_cell.widgetType.web", fallback: "웹 페이지")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension S {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
