class Api::V1::Site::PagesController < Nerdify::ApplicationController
  page :index,  model: model,
                i18n_layout: "site/pages.index",
                controller: "site/pages",
                header: { container: true, margin: { bottom: 5, top: 4 }, background_image: { url: "/assets/images/bg-kactus2.png", size: "100% auto", position: "top center" } },
                filters: { container: true },
                body: { margin: { bottom: 0, top: 5 }, background_image: { url: "/assets/images/bg-kactus2.png" } },
                footer: {},
                resources: { router: { app_search: "" } },
                without_page_header: ((model.nerdify.actions.select { |action| params = { controller: self.to_s.underscore, action: "index" }; action.name.to_sym == :index && (!action.options[:backend_if] || eval(action.options[:backend_if])) }.first || OpenStruct.new({ options: {} })).options[:without_page_header]) do
    component :container, name: :header_navigation, position: :header, size: { md: 12 } do
      component :image, name: :header_logo, src: "/assets/images/logo.png", image_size: 5, static: true
      # component :nav, name: :navigation, i18n_layout: true, items: [
      #   { name: "Inicio", link: "/" },
      #   { name: "Sobre", link: "/" },
      #   { name: "Soluções", link: "/" },
      #   { name: "Equipe", link: "/" },
      #   { name: "Contato", link: "/" }
      # ], position: :right, styles: {
      #   font_size: 3,
      #   color: "info"
      # }
      # component :button, as: :link, name: :change_language, position: :right, styles: {
      #   background: "transparent",
      #   color: "info",
      #   font_size: 4,
      #   margin: { left: 3 },
      #   orientation: { body: "horizontal" }
      # }
    end

    component :container, size: { md: 12 }, styles: { padding: { top: 5, bottom: 5 } }, position: :header do
      component :container, name: :header_text, size: { md: 6 }, styles: {
        padding: { left: 5, right: 5, bottom: 5, top: 5 },
        margin: { left: 0, right: 0, bottom: 5, top: 5 }
      } do
        component :text, type: :h1, name: :page_title, static: true, styles: { color: "light", font_weight: 5 }, animate: { time: 500, transition: "typing" }, size: { md: 12 }
        component :text, type: :h1, name: :page_title_hightlight, static: true, styles: { color: "primary", font_weight: 5 }, animate: { time: 500, delay: 500, transition: "typing" }, size: { md: 12 }
        component :text, type: :p, name: :page_description, static: true, translate: false, size: { md: 10 }, styles: { color: "info", font_size: 4, margin: { top: 3, bottom: 4 } }, animate: { delay: 1000, time: 1000, transition: "fade-in" }

        component :button, as: :link, name: :page_cta, styles: { orientation: { body: "horizontal" } }, animate: { delay: 1200, transition: "fade-in" }
      end

      component :container, name: :header_text, size: { md: 6 }, styles: { padding: { top: 5, bottom: 5, right: 5 } } do
        component :video, name: :page_video, origin: :youtube, url: "https://www.youtube.com/watch?v=nvAQyk04Kqw", size: { md: 12 }, static: true, styles: { overflow: "hidden", rounded: { top_left: 4, top_right: 4, bottom_left: 4, bottom_right: 4 } }, animate: { time: 1000, delay: 500, transition: "swiper-left", start: "200px" }
      end
    end


    component :container, name: :highlights, size: { md: 12 }, position: :header, styles: {
      align: { body: "center" },
      orientation: { body: "vertical" },
      padding: { top: 5, bottom: 5, left: 5, right: 5 }
    } do
      component :container, size: "auto", styles: { border: { top: 3 }, margin: { top: 5, bottom: 3 }, padding: { left: 3, right: 3 }, border_color: "primary" }, animate: { delay: 100, transition: "fade-in" }
      component :text, type: :h2, name: :highlights_title, static: true, styles: { color: "light", font_weight: 5 }, animate: { delay: 200, transition: "swiper-up", time: 1000, start: "200px" }
      component :text, type: :p, name: :highlights_description, static: true, translate: false, size: { md: 8 }, styles: { font_size: 4, color: "info", margin: { top: 2, bottom: 5 }, padding: { bottom: 5 } }, animate: { delay: 300, transition: "swiper-up", time: 1000, start: "200px" }

      # component :swiper, name: :swiper_highlights, resources: :highlights, size: { md: 12 }, styles: { margin: { bottom: 5 }, padding: { bottom: 5 } }, animate: { transition: "swiper-up", time: 1000, start: "100px" } do
      #   component :container do
      #     component :image, name: :image_url, styles: {
      #       overflow: "hidden",
      #       rounded: { top_left: 2, top_right: 2, bottom_left: 2, bottom_right: 2 }
      #     }
      #   end
      # end
    end


    component :container, name: :results, size: { md: 12 }, position: :header, styles: {
      padding: { top: 5, bottom: 5, left: 5, right: 5 }
    } do
      component :container, name: :header_text, size: { md: 12 }, styles: {
        orientation: { body: "vertical" },
        align: { body: "center" },
        padding: { left: 1, right: 1 }
      } do
        component :text, type: :h4, name: :results_title, static: true, styles: { color: "primary", font_weight: 5, align: { body: "center" } }, size: { md: 12 }, animate: { transition: "swiper-up", time: 1000, start: "200px" }
        component :text, type: :h2, name: :results_description, static: true, translate: false, size: { md: 8 }, styles: { font_weight: 5, color: "light", margin: { bottom: 4 }, align: { body: "center" } }, size: { md: 12 }, animate: { delay: 200, transition: "swiper-up", time: 1000, start: "200px" }

        component :list, resources: :results, size: { md: 12 }, styles: { vertical_align: { body: "stretch" } }, animate: { transition: "swiper-right", start: "-300px", time: 1000, delay: 500 } do
          component :container, size: { md: 3 }, styles: { padding: { left: 1, right: 1 } } do
            component :container, size: { md: 12 }, styles: { height: 100, orientation: { body: "horizontal" }, border: { left: 5 }, border_color: "primary", rounded: { top_left: 2, top_right: 2, bottom_left: 2, bottom_right: 2 }, background: "black", padding: { top: 2, left: 3, right: 0, bottom: 2 } } do
              component :text, type: :h1, name: :pre, styles: { color: "light", font_weight: 5 }, render_if: "resource.pre"
              component :text, type: :h1, name: :value,  styles: { color: "light", font_weight: 5 }, animate: { transition: "counter-up", time: 2000, delay: 200 }
              component :text, type: :h1, name: :pos, styles: { color: "light", font_weight: 5 }, render_if: "resource.pos"
              component :text, type: :p, name: :description, size: { md: 10 }, styles: { font_size: 4, font_weight: 5, margin: {}, padding: {}, color: "info" }
              component :text, type: :p, name: :description2, size: { md: 10 }, styles: { margin: {}, padding: {}, color: "info" }, render_if: "resource.description2"
            end
          end
        end
      end
    end


    component :container, name: :oportunities, size: { md: 12 }, position: :header, styles: {
      align: { body: "center" },
      orientation: { body: "vertical" },
      padding: { top: 5, bottom: 5, left: 5, right: 5 }
    } do
      component :container, size: "auto", styles: { border: { top: 3 }, margin: { top: 5, bottom: 3 }, padding: { left: 3, right: 3 }, border_color: "primary" }, animate: { delay: 0, transition: "fade-in" }
      component :text, type: :h2, name: :oportunities_title, static: true, styles: { color: "light", font_weight: 5 }, animate: { delay: 100, transition: "swiper-up", time: 1000, start: "200px" }
      component :text, type: :p, name: :oportunities_description, static: true, translate: false, size: { md: 8 }, styles: { color: "info", font_size: 4, margin: { top: 2, bottom: 5 }, padding: { bottom: 5 } }, animate: { delay: 200, transition: "swiper-up", time: 1000, start: "200px" }

      # component :swiper, name: :swiper_highlights, resources: :oportunities, size: { md: 12 }, styles: { margin: { bottom: 5 } }, animate: { delay: 200, transition: "swiper-left", time: 1000, start: "200px" } do
      #   component :container do
      #     component :image, name: :image_url, styles: {
      #       overflow: "hidden",
      #       rounded: { top_left: 2, top_right: 2, bottom_left: 2, bottom_right: 2 }
      #     }
      #   end
      # end
    end


    component :container, name: :impact, size: { md: 12 }, position: :header, styles: {
      padding: { top: 5, bottom: 5, left: 5, right: 5 }
    } do
      component :container, name: :header_text, size: { md: 12 }, styles: {
        orientation: { body: "vertical" },
        align: { body: "center" },
        padding: { left: 1, right: 1 }
      } do
        component :container, size: "auto", styles: { border: { top: 3 }, margin: { top: 5, bottom: 3 }, padding: { left: 3, right: 3 }, border_color: "primary" }, animate: { delay: 0, transition: "swiper-up", time: 1000, start: "200px" }
        component :text, type: :h2, name: :impact_title, static: true, styles: { color: "light", font_weight: 5 }, animate: { delay: 100, transition: "swiper-up", time: 1000, start: "200px" }
        component :text, type: :p, name: :impact_description, static: true, translate: false, size: { md: 8 }, styles: { color: "info", font_size: 4, margin: { top: 2, bottom: 2 } }, animate: { delay: 200, transition: "swiper-up", time: 1000, start: "200px" }

        component :list, resources: :impacts, size: { md: 12 }, styles: { vertical_align: { body: "stretch" } } do
          component :container, size: { md: 4 }, styles: { padding: { left: 1, right: 1 } } do
            component :container, styles: { orientation: { body: "vertical" }, padding: { top: 2, bottom: 2 }, border: { top: 5 }, border_color: "primary", height: 100, align: { body: "center" }, background: "black", rounded: { top_left: 2, top_right: 2, bottom_left: 2, bottom_right: 2 } }, animate: { delay: 500, time: 1000, transition: "swiper-up", start: "200px" } do
              component :icon, icon_type: :outlined, name: :icon, styles: { font_size: 1, color: "primary", font_weight: 5, margin: { bottom: 2 } }, animate: { delay: 500, transition: "fade-in", time: 1000 }
              component :text, type: :h3, name: :title,  styles: { color: "light", font_weight: 5, margin: { bottom: 3 } }, animate: { delay: 500, transition: "typing", time: 500 }
              component :text, type: :p, name: :description, size: { md: 10 }, styles: { font_size: 4, color: "info", margin: {}, padding: {} },  animate: { delay: 800, transition: "fade-in", time: 1000 }
            end
          end
        end
      end
    end

    component :container, name: :impact, styles: {
      width: 100,
      margin: { top: 5 },
      padding: { top: 5, bottom: 5, left: 5, right: 5 },
      background: "black"
    } do
    end
  end

  def page_json(options = {})
    json = super(options)
    json[:resources][:page] ={
      background_image: "https://sdmntprwestus.oaiusercontent.com/files/00000000-109c-6230-bf97-4854217d0d62/raw?se=2025-10-02T20%3A32%3A51Z&sp=r&sv=2024-08-04&sr=b&scid=5f3bf300-9212-506d-9607-00df5614712d&skoid=c156db82-7a33-468f-9cdd-06af263ceec8&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-10-02T18%3A08%3A49Z&ske=2025-10-03T18%3A08%3A49Z&sks=b&skv=2024-08-04&sig=q0uHhGFgtnVLVIAALb7wPsG/UZ7vWIfRqaIfhaniBwo%3D",
      background_video: ""
    }
    json[:resources][:highlights] = [
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" }
    ]
    json[:resources][:results] = [
      {
        pre: "+",
        pos: "M",
        value: 250,
        description: "milhões em VGV",
        description2: "(Valor Geral de Vendas)"
      },
      {
        pre: "+",
        value: 500,
        description: "casas entregues",
        description2: ""
      },
      {
        pre: "",
        pos: "M",
        value: 45,
        description: "milhões em ativos",
        description2: "nos setores de esporte e bem-estar"
      },
      {
        pre: "+",
        value: 4600,
        description: "lotes entregues",
        description2: ""
      }
    ]
    json[:resources][:oportunities] = [
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" },
      { image_url: "https://walldecordelights.com/cdn/shop/files/Vertical-Art-Deco-Tall-Narrow-Gold-Black-Green-Wall-Art-11.jpg?v=1744179952&width=1080" }
    ]
    json[:resources][:impacts] = [
      {
        icon: "local_florist",
        title: "Ambiental",
        description: "Nossos projetos são estruturados para máxima eficiência e valorização do ativo. Estamos construindo ativos de maior liquidez e menor risco operacional — não estamos apenas protegendo o meio ambiente, atraindo um mercado de investidores e consumidores cada vez mais conscientes."
      },
      {
        icon: "diversity_3",
        title: "Social",
        description: "Investimos em projetos que promovem bem-estar, lazer e uma vida mais saudável, reduzimos o atrito e aumentamos a aceitação social, garantindo um ambiente de negócios mais estável e favorável para o seu investimento."
      },
      {
        icon: "business",
        title: "Governança",
        description: "Operamos com total transparência e responsabilidade. Nossa governança garante que todos os negócios sejam estruturados de forma segura, ética e eficiente, oferecendo confiança e tranquilidade para o capital internacional que busca expandir seu portfólio no Brasil."
      }
    ]

    json[:translated][:components].merge!({
      header_logo: { name: "logo.png" },
      page_title: { name: "Investimento de " },
      page_title_hightlight: { name: "ALTO IMPACTO" },
      page_description: { name: "Kactus Hub é mais que gestão de ativos, é um parceiro estratégico. Desde 2009, transformamos o mercado brasileiro com projetos inovadores em imóveis, saúde, bem-estar e esportes, gerando resultados seguros e sustentáveis." },
      page_cta: { name: "Falar com especialista" },
      highlights_title: { name: "Segurança e Crescimento Comprovados" },
      highlights_description: { name: "Nossa jornada começou em 2009 com a missão de construir projetos imobiliários de alto impacto. Hoje, somos um hub completo de soluções de investimento." },
      results_title: { name: "Retorno sobre o Investimento (ROI)" },
      results_description: { name: "15% ao ano em nossos projetos mais consolidados." },
      oportunities_title: { name: "Oportunidades do Mercado Brasileiro" },
      oportunities_description: { name: "Nossa atuação oferece suporte completo a investidores internacionais. Com presença local e conexões estratégicas, identificamos e estruturamos negócios em setores como saúde e bem-estar, esportes e imóveis." },
      impact_title: { name: "Impacto Positivo" },
      impact_description: { name: "Nosso compromisso com ESG (Ambiental, Social e de Governança) é uma estratégia de valor, não apenas uma tendência. Acreditamos que a sustentabilidade é o pilar de um portfólio de alto desempenho, gerando retornos robustos e resilientes a longo prazo." }
    })
    json
  end
end
