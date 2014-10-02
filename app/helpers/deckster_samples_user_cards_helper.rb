module DecksterSamplesUserCardsHelper
  def render_new_user_summary_card
    "I am a new user!"
  end

  def render_new_user_detail_card
    "Detailed info about being a new user"
  end

  def render_user_count_summary_card
    # do some database command here to get counts of users
    count_configs = [
        {title: 'Basic Users', icon: :windows, count: 100},
        {title: 'Power Users', icon: :gmail, count: 30},
        {title: 'Admins', icon: :itunes, count: 4},
    ]

    render partial: "deckster/counts_summary_card", locals: {count_configs: count_configs}
  end

  def render_user_count_detail_card
    "Detail Information"
  end

  def render_user_photos_summary_card
    render partial: "deckster/photos_summary", locals: {deckster_photo_docs: sample_deckster_photo_docs}
  end

  def render_user_photos_detail_card
    render partial: "deckster/photos_detail", locals: {deckster_photo_docs: sample_deckster_photo_docs}
  end

  def sample_deckster_photo_docs
    [
        {id: 0, thumb_url: asset_url('sample_image.jpg'), full_url: asset_url('sample_image.jpg')},
        {id: 1, thumb_url: 'http://farm8.staticflickr.com/7405/10558271375_c1f157a517.jpg', full_url: 'http://farm8.staticflickr.com/7405/10558271375_126b5a2bf1_o.jpg'},
        {id: 2, thumb_url: 'http://farm4.staticflickr.com/3742/10557570444_15ee9144a6.jpg', full_url: 'http://farm4.staticflickr.com/3742/10557570444_4481bac4fb_o.jpg'},
        {id: 3, thumb_url: 'http://farm6.staticflickr.com/5508/10560523296_e35ee9ec75.jpg', full_url: 'http://farm6.staticflickr.com/5508/10560523296_3c56b490bd_o.jpg'},
        {id: 4, thumb_url: 'http://farm4.staticflickr.com/3759/10559782285_c3eafd3cd3.jpg', full_url: 'xxx'},
        {id: 5, thumb_url: 'http://farm6.staticflickr.com/5547/10559586043_451041ceef.jpg', full_url: 'http://farm6.staticflickr.com/5547/10559586043_88cac0fe4b_o.jpg'},
        {id: 6, thumb_url: 'http://farm4.staticflickr.com/3715/10559356816_bc0764f2fd.jpg', full_url: 'http://farm4.staticflickr.com/3715/10559356816_bd4dd66b7e_o.jpg'},
        {id: 7, thumb_url: 'http://farm3.staticflickr.com/2830/10558524593_b8e7bf20aa.jpg', full_url: 'xxx'},
        {id: 8, thumb_url: 'xxx', full_url: 'http://farm6.staticflickr.com/5522/10558118795_1f20d7741e_o.jpg'},
        {id: 9, thumb_url: 'http://farm8.staticflickr.com/7325/10556840294_da30e742c3.jpg', full_url: 'http://farm8.staticflickr.com/7325/10556840294_69cb1c92fc_o.jpg'},
        {id: 10, thumb_url: 'http://farm6.staticflickr.com/5476/10556753585_1293df91c1.jpg', full_url: 'http://farm6.staticflickr.com/5476/10556753585_94e6babf0d_o.jpg'},
        {id: 11, thumb_url: 'http://farm4.staticflickr.com/3775/10556473075_18f360b8db.jpg', full_url: 'http://farm4.staticflickr.com/3775/10556473075_a832d6bdba_o.jpg'},
        {id: 12, thumb_url: 'http://farm6.staticflickr.com/5549/10555587366_8ce3e4db51.jpg', full_url: 'http://farm6.staticflickr.com/5549/10555587366_14269181b3_o.jpg'},
        {id: 13, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 14, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 15, thumb_url: 'http://farm6.staticflickr.com/5473/10555550385_23c6a24172.jpg', full_url: 'http://farm6.staticflickr.com/5473/10555550385_68f124fa48_o.jpg'},
        {id: 16, thumb_url: 'http://farm8.staticflickr.com/7307/10555546304_8e9e8cabd6.jpg', full_url: 'http://farm8.staticflickr.com/7307/10555546304_96a5856722_o.jpg'},
        {id: 17, thumb_url: 'http://farm4.staticflickr.com/3740/10555372715_e4a5b1555e.jpg', full_url: 'http://farm4.staticflickr.com/3740/10555372715_ab24ccc95d_o.jpg'},
        {id: 18, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 19, thumb_url: 'http://farm4.staticflickr.com/3786/10855028996_460366e351.jpg', full_url: 'http://farm4.staticflickr.com/3786/10855028996_c7c2bcb403_o.jpg'},
        {id: 20, thumb_url: 'http://farm3.staticflickr.com/2862/10860969585_1a83798eb8.jpg', full_url: 'http://farm3.staticflickr.com/2862/10860969585_5961bc718d_o.jpg'},
        {id: 21, thumb_url: 'xxx', full_url: 'http://farm4.staticflickr.com/3720/10859329875_db62b38c5b_o.jpg'},
        {id: 22, thumb_url: 'xxx', full_url: 'http://farm6.staticflickr.com/5490/10858473606_d0768ffea3_o.jpg'},
        {id: 23, thumb_url: 'http://farm3.staticflickr.com/2820/10858470484_ae0b19953a.jpg', full_url: 'http://farm3.staticflickr.com/2820/10858470484_6f6f0d1877_o.jpg'},
        {id: 24, thumb_url: 'http://farm6.staticflickr.com/5531/10858142493_9b83e0e6f8.jpg', full_url: 'http://farm6.staticflickr.com/5531/10858142493_8916f956a0_o.jpg'},
        {id: 25, thumb_url: 'http://farm4.staticflickr.com/3681/10858088833_71b21fc4f3.jpg', full_url: 'http://farm4.staticflickr.com/3681/10858088833_bbc55db7b2_o.jpg'},
        {id: 26, thumb_url: 'http://farm8.staticflickr.com/7421/10857996755_cc4e6366c0.jpg', full_url: 'http://farm8.staticflickr.com/7421/10857996755_25e10472ee_o.jpg'},
        {id: 27, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 28, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 29, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 30, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 31, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 32, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 33, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 34, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 35, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 36, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 37, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 38, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 37, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 39, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 40, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 41, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 42, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 43, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 44, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 45, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 46, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 47, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 48, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 49, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 50, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 51, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 52, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 53, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 54, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 55, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 56, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 57, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 58, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 59, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 60, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 61, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 62, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 63, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 64, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 65, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 66, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 67, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 68, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 69, thumb_url: 'xxx', full_url: 'xxx'},

        {id: 70, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 71, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 72, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 73, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 74, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 75, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 76, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 77, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 78, thumb_url: 'xxx', full_url: 'xxx'},
        {id: 79, thumb_url: 'xxx', full_url: 'xxx'},
    ]
  end
end