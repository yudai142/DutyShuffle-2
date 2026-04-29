# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :worksheets, dependent: :destroy

  validates :email, presence: { message: 'は必須です' }, 
                   uniqueness: { message: 'はすでに登録されています' }

  # デモ用メンバーデータ（新スキーマに対応: name）
  DEMO_MEMBERS_DATA = [
    { name: 'テスト 太郎', archive: false },
    { name: 'テスト 花子', archive: false },
    { name: '釘子 津佳冴', archive: false },
    { name: '長谷川 異風', archive: false },
    { name: '樋口 伊吹', archive: false },
    { name: '小泉 俊一', archive: false },
    { name: '北川 優斗', archive: false },
    { name: '小股 晄', archive: false },
    { name: '田鹿 蒼史', archive: false },
    { name: '芦生 浩明', archive: false },
    { name: '高宮城 誉有治', archive: false },
    { name: '朴 清', archive: false },
    { name: '西加治工 祐樹', archive: false },
    { name: '雉子谷 茂夫', archive: false },
    { name: '渡谷 身志', archive: false },
    { name: '室石 遙摯', archive: false },
    { name: '塩足 壱', archive: false },
    { name: '筒屋 厳春', archive: false },
    { name: '日陰茂井 昊', archive: false },
    { name: '精廬 里備', archive: false },
    { name: '喜美候部 智絃', archive: false },
    { name: '竹乘 成也', archive: false },
    { name: '安達 城灯', archive: false },
    { name: '森田 悠翔', archive: false },
    { name: '矢野 英一', archive: false },
    { name: '誉田 和樹', archive: false },
    { name: '数 瑛斗', archive: false }
  ].freeze

  # デモ用タスクデータ（seed.js から複製）
  DEMO_WORKS_DATA = [
    { name: 'リーダー', multiple: 0, archive: false, is_above: false },
    { name: 'ハンディモップ', multiple: 0, archive: false, is_above: false },
    { name: 'アクリルボード', multiple: 0, archive: false, is_above: false },
    { name: 'ガラス拭き', multiple: 0, archive: false, is_above: false },
    { name: '除菌シート', multiple: 0, archive: false, is_above: false },
    { name: '窓の出っ張り', multiple: 0, archive: false, is_above: false },
    { name: 'コロコロ', multiple: 0, archive: false, is_above: false },
    { name: 'アルコール拭き', multiple: 0, archive: false, is_above: false },
    { name: '水拭き', multiple: 0, archive: false, is_above: false },
    { name: 'ゴミ捨て', multiple: 0, archive: false, is_above: false },
    { name: '掃除機', multiple: 0, archive: true, is_above: false }
  ].freeze

  # デモアカウント（test@example.com）が存在しない場合に生成
  # ※ 複数のユーザーが存在する場合でも、デモアカウントが必要なら生成される
  def self.seed_demo_user!
    # デモアカウントが既に存在する場合はスキップ
    existing_user = User.find_by(email: 'test@example.com')
    return existing_user if existing_user

    user = User.create!(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      name: 'デモユーザー'
    )

    worksheet = user.worksheets.create!(
      name: 'デモワークシート',
      interval: 1,
      week_use: false,
      week: 0
    )

    # デモメンバーデータ生成
    DEMO_MEMBERS_DATA.each do |member_data|
      worksheet.members.create!(member_data)
    end

    # デモタスクデータ生成
    DEMO_WORKS_DATA.each do |work_data|
      worksheet.works.create!(work_data)
    end

    user
  end

  # Google OmniAuthコールバック時にユーザーを検索または作成
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email    = auth.info.email
      user.name     = auth.info.name
      user.password = Devise.friendly_token[0, 20]
      user.provider = auth.provider
      user.uid      = auth.uid
    end
  end

  def display_name
    name.presence || email
  end
end
