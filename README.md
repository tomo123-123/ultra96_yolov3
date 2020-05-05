# Ultra96V2を使ったYoloV3による物体検出



[第２回AIエッジコンテスト](https://signate.jp/competitions/191)でソフトを作成した際のソースコードです。

Ultra96V2というFPGAボードを使い、YoloV3による物体検出を行います。

以下はソースコードを使ってUltra96V2を実行する方法になります。

尚、Ultra96V2での推論時やキャリブレーションで使う画像は別途用意してください。



## Vitis AIプラットフォームの作成など



今回、FPGAにはDPU IPコアを使用しており、[Ultra96V2向けVitis AI(2019.2)の組み立て方](https://qiita.com/basaro_k/items/e71a7fcb1125cf8df7d2)というサイトを参考にさせていただき、プラットフォームを構築しました。とても参考になりました、ありがとうございました。

まず、開発環境の構築などは、リンク先の情報を確認して構築してください。

### DPUをB1152からB2304への変更して高速化

次に『Vitis AIプラットフォームの作成方法』の章にてultra96x.shの『B1152/g』を検索して『B2304/g』へ変更します。

これで、DPUがB1152からB2304に変更して構築することができます。

『SDカードの生成』の章まではそのまま行ってください。その後は下の手順を行ってください。



## （参考）Darknetで作成した重みファイルを量子化



この手順はDarknetで重みファイルを作成する方向けの手順です。量子化した重みファイルは用意してありますので、とりあえず普通に試す方は飛ばしてください。

また、開発中盤まではSDx 2018.3にて作っていたため、下のような手順ですが、もっと良い手順があると思います。

Xilinx社が作成したGithubの『Edge AI Tutorials』の『YOLOv3 Tutorial: Darknet to Caffe to Xilinx DNNDK』（本家のページは少し前に削除されてしまい、探すと他に見つかります）というページを参考にVitis AIでも使えるようにカスタマイズしました。



まずチュートリアルの別環境を仮想環境などで作成し、『example_yolov3』フォルダはアップロードしている物に差し替え、自前で作った『yolov3.weights』、『yolov3.cfg』を『0_model_darknet』にコピーします。

その後の『Step 3: Quantize the Caffe Model』まで行います。

尚、『5_file_for_test/calib_data』のキャリブレーション用の画像は別途用意してください。



次に『Ultra96V2向けVitis AI(2019.2)の組み立て方』の環境に『example_yolov3』をコピーし、以下のコマンドを実行します。

```
./docker_run.sh xilinx/vitis-ai:tools-1.0.0-cpu
```

『Ultra96V2向けVitis AI(2019.2)の組み立て方』の『ハードウェア情報ファイル。』の作業を行い、dcfファイルを作成します。

次に『FPGAデータの作成』の作業を行い、『ultra96v2_obb.json』を編集します。

『3_compile_ultra96.sh』を実行して量子化した重みファイル『4_model_elf/dpu_yolo.elf』を作成します。



結局、darknetからcaffeへ変換するdarknet2caffeがpython2にしか対応していないため、手順が複雑になっています。



## アプリケーションの作成

コンパイル済みのソフトもアップロードしています。とりあえず試す方は、makeするまでは飛ばしてください。

『Ultra96V2向けVitis AI(2019.2)の組み立て方。』の『アプリケーションを作成する。』を参考にして、『resnet50』から『yolov3』に置き換えて手順を行い、SDカードには、アプリケーションの『yolov3』フォルダごと『/media/$USER/root/home/root』にコピーしてください。

次に、SDカードの『/media/$USER/root/dtc_test_images/』に推論する1936×1216の画像を別途用意してコピーします。この際に『yolov3/testlist.txt』のファイル内の画像名で推論するので、名前を合わせてください。





## Ultra96V2を使った操作



### 環境準備

Ultra96V2にJTAGを接続して、USBよりシリアル接続ができる環境を整えます。
また接続PC（Ubuntuを想定）側にもシリアル接続用のドライバをインストールしておきます。

JTAGがない方は、『Ultra96V2向けVitis AI(2019.2)の組み立て方。』を参考にWi-Fiで接続も可能です。



### アプリケーションの簡単な説明

  ・このアプリケーションは、『testlist.txt』に登録されている画像ファイルを開いて推論するプログラムです。
  ・結果は『outdata』にファイルごとのCSVファイルとして保存されます。



### Ultra96V2の操作方法

・Ultra96V2を起動します。

・接続用PCより『gtkterm -p /dev/ttyUSB1 -s 115200』などと入力して、GtkTerm画面が開き、接続できることを確認。

・GtkTerm画面より、
       cd ./yolov3/
       ./yolov3 testlist.txt f > 20200323.csv(日付などの任意のファイル名)
      を入力し、終了するまで待ちます。

・GtkTerm画面より、
      sync
      shutdown -h now
      と入力して、ultra96V2をシャットダウンします。

・Ultra96V2の電源は自動的には落ちないので、電源ボタンを押して電源を切ります。



### CSVファイルからJSONファイルへの変換方法

推論した際に『yolov3/output』にはCSVファイルが出力されます。これを提出用のJSONファイルに変換するには、outputフォルダをzipで圧縮し、PCへファイルを取り出します。

『Google Colaboratory』などで『CSV_to_Submitfile.ipynb』を開き、『output.zip』をアップロードして実行してJSONファイルを作成します。