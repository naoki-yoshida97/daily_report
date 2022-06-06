## bitcoin-cli　をしようとしたらdyld系のエラーが出た話

bitcoin-cliコマンドで残高やトランザクションを確認しようとしたらなんか出てきた

'''
➜  ~ bitcoin-cli listunpent
dyld[5867]: Symbol not found: __ZN5boost10filesystem4pathdVERKS1_
  Referenced from: /usr/local/bin/bitcoin-cli
  Expected in: /usr/local/Cellar/boost/1.78.0_1/lib/libboost_filesystem.dylib
[1]    5867 abort      bitcoin-cli listunpent
'''

何これ

ちょっと調べたらこれが見つかった
<https://blog.enjoitech.com/article/216>

2022-05-30 17:24:20.427 xcodebuild[6388:100598] Requested but did not find extension point with identifier Xcode.IDEKit.ExtensionSentinelHostApplications for extension Xcode.DebuggerFoundation.AppExtensionHosts.watchOS of plug-in com.apple.dt.IDEWatchSupportCore
2022-05-30 17:24:20.428 xcodebuild[6388:100598] Requested but did not find extension point with identifier Xcode.IDEKit.ExtensionPointIdentifierToBundleIdentifier for extension Xcode.DebuggerFoundation.AppExtensionToBundleIdentifierMap.watchOS of plug-in com.apple.dt.IDEWatchSupportCore
xcodebuild[6388:100598] プラグイン com.apple.dt.IDEWatchSupportCore の拡張機能 Xcode.DebuggerFoundation.AppExtensionHosts.watchOS に対する識別子 Xcode.IDEKit.ExtensionSentinelHostApplications の拡張ポイントを要求されましたが、見つかりませんでした。
2022-05-30 17:24:20.428 xcodebuild[6388:100598] プラグイン com.apple.dt.IDEWatchSupportCore の拡張機能 Xcode.IDEKit.AppExtensionPointIdentifierToBundleIdentifierMap.watchOS に対する識別子 Xcode.IDEKit.ExtensionPointIdentifier を持つ拡張ポイントを要求しましたが、見つかりませんでした。

・・・貴様〜。見つけられぬと申すかっ！

/usr/local/bin/bitcoin-cli:
 /usr/local/opt/boost/lib/libboost_filesystem.dylib (compatibility version 0.0.0, current version 0.0.0)
 /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1281.0.0)
 /usr/local/opt/libevent/lib/libevent-2.1.7.dylib (compatibility version 8.0.0, current version 8.1.0)
 /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 800.7.0)


直った後
otool -L /usr/local/bin/bitcoin-cli
/usr/local/bin/bitcoin-cli:
 /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1311.100.3)
 /usr/local/opt/libevent/lib/libevent-2.1.7.dylib (compatibility version 8.0.0, current version 8.1.0)
 /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 1300.23.0)






