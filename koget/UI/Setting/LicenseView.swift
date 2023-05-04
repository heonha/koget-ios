//
//  LicenseView.swift
//  koget
//
//  Created by Heonjin Ha on 2023/03/19.
//

import SwiftUI

struct LicenseView: View {

    let title = S.License.title
    let license =
    """
    The MIT License

    Copyright (c) 2023 koget

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
    """

    var body: some View {
        VStack {
            Text(title)
                .font(.custom(CustomFont.NotoSansKR.bold, size: 18))
                .padding(.bottom, 4)

            ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColor.Fill.third)
                    Text(license)
                        .font(.custom(CustomFont.NotoSansKR.light, size: 14))
                        .padding(8)
                }
            }
        }
        .padding()
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}