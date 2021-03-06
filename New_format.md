# JAdESフォーマット

## 先進署名フォーマット「JAdES」とは
「誰がデジタル署名したのか」を確認できる署名データの形式として先進署名(AdES: Advanced Electronic Signature、高度電子署名とも呼ばれるフォーマット

先進フォーマットにはすでに国際化標準されている「ASN.1バイナリ形式」,「PDF形式」,「XML形式」に「JSON形式」を対応させたもの


| データ<br>フォーマット | ASN.1バイナリ                                                                     | XML                        | PDF                        | ZIP          | JSON       |
| ---------------------- | --------------------------------------------------------------------------------- | -------------------------- | -------------------------- | ------------ | ---------- |
| 主な用途               | データ一般、デジタルタイムスタンプ、署名メール、コード署名、PAdES内部の署名値など | 医療、建築、電子商取引など | 電子文書一般、電子契約など | ファイル一般 | ウェブ領域 |
| 署名フォーマット       | CMS<br>SingedData                                                                 | XML署名                    | PDF署名                    | なし         | JWS        |
| 先進署名フォーマット   | CAdES                                                                             | XAdES                      | PAdES                      | ASIC         | JAdES      |


jsonのデータ形式
'''
{"名前":"値1","名前2":"値2",...}
'''

## JWS署名で保護される情報

署名者の証明者の参考情報
署名アルゴリズム
署名場所
署名の意思表示
どのような条件下で署名や検証するかを示す署名ポリシーの識別情報
など

## JWS署名で保護されない情報(アーカイブタイムスタンプ等で保護)

第三者が証明する署名時刻(署名タイムスタンプ)
長期で検証に必要となる証明書や失効情報のデータ
長期で検証に必要となる証明書や失効情報のデータの参照情報
検証可能期間を延長するためのアーカイブタイムスタンプ
カウンタ署名
など

## 様々な署名フォーマットと比較した「JAdES」の特徴
先進署名フォーマットCAdES、XAdESと比較して、JSONやJWSをベースにしていることにより以下の特徴
'''
SONデータを元にしておりデータの読み込みが簡単で、ASN.1やXMLといった特別なパーザー[1]を必要としない。
ウェブサイト間の取引での利用に適している。
XMLよりは署名データのサイズが小さいが、CAdESよりは大きい。

[1] パーザー：コンピュータプログラムのソースコードなど、何らかの言語で記述された構造的な文字データを解析し、プログラムで扱えるように構文解析を行うためのプログラムの総称。
'''

署名フォーマットJWSと比較した際に、JAdESとしてCAdESやXAdESと同様に以下の特徴

'''
署名データと、署名者のデジタル証明書とを強固に紐付けている。
署名者や署名データに関する属性情報の表記が可能。
暗号アルゴリズムの移行、ルート認証局の移行などに対応して長期に渡る検証、検証期間の延長が可能。
(署名者証明書との紐付けが必要なため)HMACによる署名は利用できない。
'''

先進署名フォーマットCAdESやXAdESと比較した場合に、JAdESには以下の特徴

'''

CAdESと比較して、XAdESと同様に外部署名(detached署名)の署名対象との参照関係を記述できる。
外部署名のための特別な属性(“sigD”オブジェクト)を持つ。
CAdES、XAdESと異なりHTTPプロトコルにおいて、HTTPヘッダー、ボディをJAdES署名で保護するための方法を規定している。

'''

## 先進署名と適格署名、普通のデジタル署名の違い
- RSA署名やECDSAなどの署名アルゴリズムを用いて行った基本的な署名
- CMS SignedData、XML署名、PDF署名、JWSなどの署名フォーマットによる署名
- 先進署名フォーマット(AdES)による署名
- 欧州 適格電子署名、適格eシール


## 基本的なデジタル署名(RSA署名、ECDSA等)
- 秘密鍵、公開鍵さえあれば証明書はなくても署名が可能
- 公開鍵に紐づく秘密鍵で署名され、改ざんされていないことのみ確認可能
- 誰が署名したか、署名データ自体からは不明

## 署名フォーマット(CMS署名、XML署名、PDF署名、JWS、S/MIME署名メール、コード署名等)
- どの公開鍵証明書に紐づく秘密鍵で署名されたのか確認可能
- 公開鍵証明書と署名の結びつきが弱い
- 発行者とシリアル番号が同一の証明書が不正発行されていて区別が不可能
- 署名時刻など最小限の署名に関する属性情報が定義されている

## 署名時刻など最小限の署名に関する属性情報が定義されている
- 署名フォーマット(CMS署名、XML署名、PDF署名、JWS、S/MIME署名メール、コード署名に対して署名に補足する属性の追加
- 公開鍵証明書と署名の結びつきを厳格にできる
- 署名時刻を第三者保証でき、証明書の失効の有無を厳格に判可能
- 公開鍵証明書が有効期限切れとなっても署名の有効性を確認可能
- 署名の意図や署名場所など、署名に関する補足的な属性が定義されており、これを追加可能

