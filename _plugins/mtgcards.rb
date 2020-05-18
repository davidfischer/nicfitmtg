# Add additional "Tags" that render links to cards, images of cards, or whole decks.
#
# Here's some examples of linking to specific cards:
#  {% mtgcardlink Veteran Explorer %}
#  {% mtgcardlink Delver of Secrets // Insectile Aberration | Delver %}
#
# Here's some examples of showing images of specific cards:
#  {% mtgcardimg Cabal Therapy %}
#  {% mtgcardimg Thragtusk %}
#
# Here's some examples of showing a hand of cards:
#  {% mtghand %}
#    4 Veteran Explorer
#    4 Cabal Therapy
#    4 Green Sun's Zenith
#    ...
#  {% endmtgdeck %}
#
# For more info on Jekyll/Liquid tags, see https://jekyllrb.com/docs/liquid/tags/
#
# I'm a pretty poor Ruby developer so please forgive me...
require 'erb'
require 'json'


def get_mtg_cards
  print "Reading Scryfall card data...\n"
  filepath = File.expand_path('scryfall-oracle-cards.json', File.dirname(__FILE__))
  file = File.open filepath
  card_list = JSON.load file
  file.close

  # Reorganize the cards by name
  card_hash = Hash.new  # name -> obj
  for card in card_list do
    card_hash[card["name"]] = card
  end

  return card_hash
end

# There are a few different ways to get an image for a card
# Some cards like double faced ones have multiple images, etc.
def get_card_image_url(card, image_type="border_crop")
  image_url = nil

  if card.key? "image_uris"
    image_url = card["image_uris"][image_type]
  elsif card.key? "card_faces" and card["card_faces"].length > 0 and card["card_faces"][0].key? "image_uris"
    image_url = card["card_faces"][0]["image_uris"][image_type]
  end

  return image_url
end

MTGCARDS = get_mtg_cards


module Jekyll

  # Renders a link to a given card
  #
  # Examples:
  #  {% mtgcardlink Veteran Explorer %}
  #  {% mtgcardlink Veteran Explorer | Vet %}
  class RenderCardLinkTag < Liquid::Tag

    TEMPLATE = %{
      <a class="mtgcardlink"
         href="<%= card["scryfall_uri"] %>"
         data-mtg-cardname="<%= card["name"] %>"
         data-mtg-id="<%= card["id"] %>"
         data-mtg-scryfall-url="<%= card["scryfall_uri"] %>"
         data-mtg-image-url="<%= image_url %>"
         data-mtg-tcgplayer-id="<%= card["tcgplayer_id"] %>"
         data-mtg-mtgo-id="<%= card["mtgo_id"] %>"
      ><%= display_name %></a>
    }

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      input_split = @text.split('|')

      card_name = input_split[0].strip
      display_name = card_name
      if input_split.length > 1
        display_name = input_split[1].strip
      end

      card = MTGCARDS[card_name]

      # Try expanding the card name as a variable
      if not card and context[card_name]
        card_name = context[card_name]
        display_name = card_name
        card = MTGCARDS[card_name]
      end

      if not card
        raise "Invalid card '#{card_name}'!"
      end

      image_url = get_card_image_url(card)

      renderer = ERB.new(TEMPLATE)
      renderer.result(binding).strip
    end
  end


  # Renders an image for a given card
  #
  # Examples:
  #  {% mtgcardimg Thalia, Guardian of Thraben %}
  #  {% mtgcardimg Delver of Secrets // Insectile Aberration %}
  class RenderCardImgTag < RenderCardLinkTag

    TEMPLATE = %{
      <a class="mtgcardimglink"
         href="<%= card["scryfall_uri"] %>"
         data-mtg-cardname="<%= card["name"] %>"
         data-mtg-id="<%= card["id"] %>"
         data-mtg-scryfall-url="<%= card["scryfall_uri"] %>"
         data-mtg-image-url="<%= image_url %>"
         data-mtg-tcgplayer-id="<%= card["tcgplayer_id"] %>"
         data-mtg-mtgo-id="<%= card["mtgo_id"] %>"
      >
        <img src="<%= image_url %>" alt="<%= card["name"] %>">
      </a>
    }

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      card_name = @text.strip
      card = MTGCARDS[card_name]

      # Try expanding the card name as a variable
      if not card and context[card_name]
        card_name = context[card_name]
        display_name = card_name
        card = MTGCARDS[card_name]
      end

      if not card
        raise "Invalid card '#{card_name}'!"
      end

      image_url = get_card_image_url(card)

      if not image_url
        raise "No image for '#{card_name}'!"
      end

      renderer = ERB.new(TEMPLATE)
      renderer.result(binding).strip
    end
  end


  # Renders a hand/group of cards
  #
  # Examples:
  #  {% mtghand %}
  #  Veteran Explorer
  #  Cabal Therapy
  #  {% endmtghand %}
  class RenderHandBlock < Liquid::Block

    TEMPLATE = %{
      <div class="mtghand">
        <% cards.each do |card| %>
          <a class="mtgcardimglink"
             href="<%= card["scryfall_uri"] %>"
             data-mtg-cardname="<%= card["name"] %>"
             data-mtg-id="<%= card["id"] %>"
             data-mtg-scryfall-url="<%= card["scryfall_uri"] %>"
             data-mtg-image-url="<%= card["image_url"] %>"
             data-mtg-tcgplayer-id="<%= card["tcgplayer_id"] %>"
             data-mtg-mtgo-id="<%= card["mtgo_id"] %>"
          >
            <img src="<%= card["image_url"] %>" alt="<%= card["name"] %>">
          </a>
        <% end %>
      </div>
    }

    def render(context)
      text = super

      cards = []

      for card_name in text.split("\n") do
        card_name = card_name.strip

        if card_name.empty?
          next
        end

        card = MTGCARDS[card_name]
        if not card
          raise "Invalid card '#{card_name}'!"
        end

        card["image_url"] = get_card_image_url(card)
        cards.push(card)
      end

      renderer = ERB.new(TEMPLATE)
      renderer.result(binding).strip
    end
  end
end

Liquid::Template.register_tag('mtgcardlink', Jekyll::RenderCardLinkTag)
Liquid::Template.register_tag('mtgcardimg', Jekyll::RenderCardImgTag)
Liquid::Template.register_tag('mtghand', Jekyll::RenderHandBlock)
