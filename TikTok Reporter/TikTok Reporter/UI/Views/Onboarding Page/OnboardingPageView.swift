//
//  OnboardingPageView.swift
//  TikTok Reporter
//
//  Created by Sergiu Ghiran on 04.11.2023.
//

import SwiftUI

struct OnboardingPageView: View {

    // MARK: - Properties

    var onboardingStep: OnboardingStep
    @Binding
    var contentInset: CGFloat

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: .m) {

                title
                subtitle
                description
                image

                if onboardingStep.details != nil {
                    details
                }
            }
            .padding([.horizontal, .top], .xl)
            .padding(.bottom, contentInset)
        }
    }

    // MARK: - Views

    private var title: some View {

        Text(onboardingStep.title)
            .font(.heading3)
            .foregroundStyle(.text)
    }

    private var subtitle: some View {

        Text(onboardingStep.subtitle)
            .font(.heading5)
            .foregroundStyle(.basicRed)
    }

    private var description: some View {

        Text(onboardingStep.description)
            .font(.body1)
            .foregroundStyle(.text)
    }

    private var image: some View {

        AsyncImage(url: URL(string: onboardingStep.imageUrl)!) { image in

            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2.0, anchor: .center)
        }
        .frame(width: UIScreen.main.bounds.width * 0.43)
        .frame(maxWidth: .infinity)
    }

    private var details: some View {

        Text(onboardingStep.details!)
            .font(.body2)
            .foregroundStyle(.text)
    }
}

// MARK: - Preview

#Preview {
    OnboardingPageView(onboardingStep:
                        OnboardingStep(
                            id: "",
                            title: "Here is how you can use the app to share videos with us you are seeing",
                            subtitle: "Sharing a link",
                            description: "Select share button in TikTok.",
                            imageUrl: "https://ffd82d1a47a161772b7db3b1fb669d653d72c05e4c6c6653f1ab363-apidata.googleusercontent.com/download/storage/v1/b/regrets_reporter_onboarding_docs/o/Onboarding%20image%20-%20recording%20-%20step%201.png?jk=AQHBpxzkSRXerghmZ0lsrgFvAr19q6UVXY8lJmLfyWiBoc2qdtPO32WmYt2ZjodPAZD6lMqAoyawEzsrQ6GJuw4Ih64W0viRdTGMwCzj2yVwp8gr7sjERdjDFFkihpInbNk_TiWVkLYJtByTY_TdziNmuvK8KxkPK51UGvkqAa_HtE735m2TVy8EmwMrOFJX7V1shY3oey4RTXeKR3H8AeYKNfOtEG8GFZTDgKdN561ay2JU4HDVR3iVyLCja_JuewpBXlqOvHUpqDnjoY8mZm64sFPXCfjwWWovYX9tm8ihwE5DqNcVsXN5Z_QF1xBjTQakAXTe2XpCrCSWMFOEDkFD66NnopUmfLjUCyMWs1m71mzCX8Z1D0rEFX4dfPQ3D3NynRZfE2g6yDg9yI7K5rU_iW8UtCLXlVxwAVpH28xJD-bCh_bSD253puntx8SybcAwGrvGIRf8zeqp6ViWsfldNiFPh3XWbwLYzITCJGU2e4KUiVDzHTevhi0-bIb1mSNJvsmQX-wUIawMkuRT9rT1GOvEY_UYuCDKm1l3ok2GgXuLj0FT_mmUUOEOTTG7pvVmCKfnGWb9LIaZiM_-KW3bnhzcPfcixsCg2dMB3K16BnBY3MRoWV_DgTyQFGcBdkFFNWkX4BPrHIdZCrYV1ZoNO68YTAV_T3TNt9H_PkjHEW426coVHfQ7rP5qzOdGwbOQlRaUACmft4LZIY3Kd0JtjyR2CSsOrlx3R8nck9mNF9Ebna5bSFTPmNHO2RgxjaD5qtIbarNDVtKzHOFKHsCED9mYezZdSIUtjvUKTrBeANTO2IoD7fEhaI9It_lvcb9R_6gNBa_b9TiVgGHl82cFyyz7xGnT9cEjcU6WKh_50MkCcXvZGmlD05slntO48f5G40w2FEqO_ev18RYZKhkvpp2xdLLIp5Rfo8EZqH85cSAQdDbg4iCxykzRLYqDWafiyDbGO2dadVit9BbqB4w-RzdBJnhiE7TRhB9e4CAAzvY5udwKIhLZHFBNmUb4JDnJ6ndNsxsONsCG93747s1qA3elScQM1Q-eLnWwe8gSKKgJVfBeApsYHmVtf1KTqpHOXzGLH01ytgqZHCbnFqKkaRVE0ru0J6PfRo8DKJMfJ79i5B4NHbtxlSRHr65bQg2lA3_QTHSUpHEJbdJkV2oIf9NKr6F4lehbd3kDvxB_eLMZPdWqwgG4hv8RcZwtjvnGXES8vtK6OymuDFcJUOMVnOPQLZm8kh1JN3chG61NOTNrfD_gN32Nupg_9-mOM5gmppVmJG4k4g&isca=1",
                            details: nil,
                            order: 1,
                            onboardings: []
                        ),
                       contentInset: .constant(.xl)
    )
}
