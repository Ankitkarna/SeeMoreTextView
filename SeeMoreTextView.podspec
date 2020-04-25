
Pod::Spec.new do |spec|

  spec.name         = "SeeMoreTextView"
  spec.version      = "0.0.1"
  spec.summary      = "Expandable see more in textview"

    spec.homepage = "https://github.com/Ankitkarna/SeeMoreTextView"
    spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Ankit" => "ankit.karna2011@gmail.com" }

   spec.platform     = :ios, "11.0"


  spec.source       = { :git => "https://github.com/Ankitkarna/SeeMoreTextView.git", :tag => "#{spec.version}" }


  spec.source_files  = "SeeMoreTextView/Sources"

end
