# coding: utf-8

require 'base64'

class Common < Lita::Handler
  route(/^xor ([^ ]+) ([^ ]+)/i) do |response|
    begin
      data = Base64.decode64(response.args[0])
      key = Base64.decode64(response.args[1])

      output = data.bytes.zip(key.bytes.cycle).map { |x|
        x.reduce(:^).chr
      }.join

      response.reply(output.inspect)
    rescue
      response.reply("Usage: xor [base64 data] [base64 key]")
    end
  end

  route(/^ici$/i) do |response|
    response.reply('et maintenant')
  end

  route(/ici et maintenant/i) do |response|
    response.reply('https://www.youtube.com/watch?v=DMeyvg1M52k')
  end

  route(/^allo allo$/i) do |response|
    if Time.new.to_i.even?
      response.reply('Monsieur l\'ordinateur :dorothee:')
    else
      phrases = ['Just pick up the phone', 'I wonder what they wanna know', 'They wanna know, comme allo allo', 'I just wanna let you know']
      response.reply(phrases.sample + ' :telephone_receiver:')
    end
  end

  route(/^lenny$/i) do |response|
    response.reply('( ͡° ͜ʖ ͡°)')
  end

  route(/^lennyorgy$/i) do |response|
    response.reply('( ͡°( ͡° ͜ʖ( ͡° ͜ʖ ͡°)ʖ ͡°) ͡°)')
  end

  route(/^8ball/i, command: true) do |response|
    phrases = ['It is certain', 'It is decidedly so', 'Without a doubt', 'Yes definitely', 'You may rely on it', 'As I see it, yes', 'Most likely', 'Outlook good', 'Yes', 'Signs point to yes', 'Reply hazy try again', 'Ask again later', 'Better not tell you now', 'Cannot predict now', 'Concentrate and ask again', 'Don\'t count on it', 'My reply is no', 'My sources say no', 'Outlook not so good', 'Very doubtful']
    response.reply(phrases.sample + ' :8ball:')
  end

  route(/^montre nous tes fesses$/i, command: true) do |response|
    response.reply('( ＾◡＾)っ (‿|‿)')
  end

  route(/^koi$/i, command: true) do |response|
    response.reply("Je revenais de faire mon voyage de coopération internationale au Sénégal et les filles du groupe me l'on créé ... Confit pour confiture, parce que se salué dans le dialecte cerrer-lala tu dit \"jammm\" comme confiture en anglais et le phil c'était parce que mon nom d'adoption au Sénégal c'était Philippe")
  end

  route(/^Je revenais de faire mon voyage de coopération internationale au Sénégal et les filles du groupe me l'on créé ... Confit pour confiture, parce que se salué dans le dialecte cerrer-lala tu dit \"jammm\" comme confiture en anglais et le phil c'était parce que mon nom d'adoption au Sénégal c'était Philippe$/i, command: false) do |response|
    response.reply("koi")
  end

  route(/^\+1( :[\w\-\+:]+:)?( :[\w\-\+:]+:)?$/, command: true) do |response|
    message = '''_0__0__0__0__0__0__0__0__0__0_
_0__0__0__0__0__0__1__0__0__0_
_0__0__0__0__0__1__1__0__0__0_
_0__0__1__0__0__0__1__0__0__0_
_0__1__1__1__0__0__1__0__0__0_
_0__0__1__0__0__0__1__0__0__0_
_0__0__0__0__0__0__1__0__0__0_
_0__0__0__0__0__1__1__1__0__0_
_0__0__0__0__0__0__0__0__0__0_'''

    message.gsub!(/_0_/, response.args[0] || ':ship:')
    message.gsub!(/_1_/, response.args[1] || ':+1:')
    response.reply(message)
  end

  route(/^-1( :[\w\-\+:]+:)?( :[\w\-\+:]+:)?$/, command: true) do |response|
    message = '''_0__0__0__0__0__0__0__0__0__0_
_0__0__0__0__0__0__1__0__0__0_
_0__0__0__0__0__1__1__0__0__0_
_0__0__0__0__0__0__1__0__0__0_
_0__1__1__1__0__0__1__0__0__0_
_0__0__0__0__0__0__1__0__0__0_
_0__0__0__0__0__0__1__0__0__0_
_0__0__0__0__0__1__1__1__0__0_
_0__0__0__0__0__0__0__0__0__0_'''

    message.gsub!(/_0_/, response.args[0] || ':ship:')
    message.gsub!(/_1_/, response.args[1] || ':-1:')
    response.reply(message)
  end


  LATEX_URL = URI::HTTP.build(host: 'chart.apis.google.com', path: '/chart', fragment:'.png').freeze

  route %r(\A(?:tex|latex)(?:\s+me)?\s+(.*)\Z), :latex, command: true do
    expression = CGI.escape(response.matches.first.first)
    response.reply image_url(expression)
  end

  route(/countdown/i, command: false) do |response|
    count = (Date.new(2019, 03, 22) - Date.today).to_i
    response.reply ":cs-games: *#{count} jours* avant les CS Games :cs-games:"
  end

  Lita.register_handler(self)

  private

  def image_url(expression)
    LATEX_URL.dup.tap { |url|
      url.query = "cht=tx&chl=#{ expression }"
    }.to_s
  end
end
