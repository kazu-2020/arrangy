module ApplicationHelper
  def default_meta_tags
    {
      og: {
        title: 'Arrangy(アレンジー) | コンビニ商品や外食店の料理を使用したアレンジ飯の共有サービス',
        url: 'https://arrangy.jp',
        description: 'Arrangy(アレンジー)はアレンジ飯の共有サービスです。コンビニ商品や外食店の料理を使用したアレンジ飯を「知りたい」「共有したい」という方達は、是非覗いてみてください!!',
        image: 'https://arrangy.jp/images/og-image.png'
      },
      twitter: {
        card: 'summary_large-image',
        site: '@Arrangy1'
      },
      viewport: 'width=device-width, initial-scale=1'
    }
  end
end
