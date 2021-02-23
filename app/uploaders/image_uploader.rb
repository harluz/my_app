# frozen_string_literal: true

class ImageUploader < CarrierWave::Uploader::Base
  # リサイズしたり画像形式を変更するのに必要
  include CarrierWave::RMagick

  # アップロードした画像の表示
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # デフォルト画像の設定
  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*_args)
    #   For Rails 3.1+ asset pipeline compatibility:
    ActionController::Base.helpers.asset_path('/images/' + [version_name, 'default.png'].compact.join('_'))
    #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  # 画像の上限を640x480にする
  process resize_to_limit: [640, 480]

  # 保存形式をJPGにする
  process convert: 'jpg'

  # サムネイルを生成する設定
  # version :thumb do
  #   process resize_to_limit: [300, 300]
  # end

  # version :thumb100 do
  #   process resize_to_limit: [100, 100]
  # end

  version :thumb30 do
    process resize_to_limit: [30, 30]
  end

  version :thumb300 do
    process resize_to_limit: [300, 300]
  end

  # jpg,jpeg,gif,pngしか受け付けない
  def extension_white_list
    %w[jpg jpeg gif png]
  end

  # 拡張子が同じでないとGIFをJPGとかにコンバートできないので、ファイル名を変更
  def filename
    super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
  end

  # ファイル名を日付にするとタイミングのせいでサムネイル名がずれる
  # ファイル名はランダムで一意になる
  #   def filename
  #     "#{secure_token}.#{file.extension}" if original_filename.present?
  #   end

  #   protected

  #   def secure_token
  #     var = :"@#{mounted_as}_secure_token"
  #     model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  #   end
end
