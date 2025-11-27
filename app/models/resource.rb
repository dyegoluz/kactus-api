class Resource
  include Nerdify::Model
  orm :mongoid

  # Actions
  # Ações que podem ser relacionadas a um objeto ou uma coleção desta classe
  # São adicionadas ao modelo através do método action passando o nome da ação e opções de personalização
  # Essas ações são usadas para criar botões e rotas
  # Cada ação pode receber as seguintes opções:
  #   - only: usado para determinar onde haverá um botão para esta ação, (exemplo: only: %w(index show edit))
  #   - on: determinar se a ação é vinculada a uma coleção ou a um objeto através das opções :collection ou :member
  #   - position: determina a posição que o botão deve aparecer no layout
  #   - layout: define o layout que será usado para carregar a página (default, embed ou dialog)
  #   - click: hash de opções de ação para quando clicar no botão
  #   - submit: hash de opções de envio de formulário daquela página
  #   - backend_if: condição de renderização no backend
  #   - render_if: condição de renderização no frontend
  # ---------------------------------------------------------------------------------------------------------------
  # Exemplo para um controlador com layout default
  action :index
  action :show, layout: :default
  action :edit, only: %w(show), on: :member, position: :header, layout: :default, click: {redirect_to: "edit"}, submit: {put: "..", data: {:resource => ":resource"}, success: {redirect_to: "..", toast: :success}, error: {toast: :error, update: "components"}}
  action :edit_cancel, only: %w(edit), on: :member, position: :footer, click: {redirect_to: ".."}
  action :update, only: %w(edit), on: :member,position: :footer, click: {submit: "edit_resource"}
  action :new, only: %w(index), on: :collection, position: :header, layout: :default, click: {redirect_to: "new"}, submit: {post: "..", data: {:resource =>  ":resource"}, success: {redirect_to: "..", toast: :success}, error: {toast: :error, update: "components"}}
  action :new_cancel, only: %w(new), on: :member,position: :footer, click: {redirect_to: ".."}
  action :create, only: %w(new), on: :member,position: :footer, click: {submit: "new_resource"}
  action :destroy, only: %w(show), on: :member,position: :header, layout: :default, click: {delete: ".", confirm: true, success: {redirect_to: "..", toast: :success}, error: {toast: :error}}
  # ---------------------------------------------------------------------------------------------------------------
  # Exemplo para um controlador com layout modal
  # action :index
  # action :show, layout: :modal
  # action :edit, only: %w(show), on: :member, position: :footer, layout: :modal, click: {redirect_to: "edit", open_in: :dialog}, submit: {put: "..", data: {:resource => ":resource"}, success: {redirect_to: "..", open_in: :dialog, toast: :success}, error: {toast: :error, update: "components"}}
  # action :edit_cancel, only: %w(edit), on: :member, position: :footer, click: {redirect_to: "..", open_in: :dialog}
  # action :update, only: %w(edit), on: :member,position: :footer, click: {submit: "edit_resource"}
  # action :new, only: %w(index), on: :collection, position: :header, layout: :modal, click: {redirect_to: "new", open_in: :dialog}, submit: {post: "..", data: {:resource =>  ":resource"}, success: {close: :dialog, toast: :success}, error: {toast: :error, update: "components"}}
  # action :new_cancel, only: %w(new), on: :member,position: :footer, click: {close: :dialog}
  # action :create, only: %w(new), on: :member,position: :footer, click: {submit: "new_resource"}
  # action :destroy, only: %w(show), on: :member,position: :footer, layout: :modal, click: {delete: ".", confirm: true, success: {close: :dialog, toast: :success}, error: {toast: :error}}
  # action :sort, only: %w(), on: :collection, method: :post
  # ---------------------------------------------------------------------------------------------------------------
  # Exemplo para um controlador com layout embed
  # action :index
  # action :show, layout: :embed
  # action :edit, only: %w(show), on: :member, position: :footer, layout: :modal, click: {redirect_to: "edit", open_in: :dialog}, submit: {put: "..", data: {:resource => ":resource"}, success: {redirect_to: "..", open_in: :dialog, toast: :success}, error: {toast: :error, update: "components"}}
  # action :edit_cancel, only: %w(edit), on: :member, position: :footer, click: {redirect_to: "..", open_in: :dialog}
  # action :update, only: %w(edit), on: :member,position: :footer, click: {submit: "edit_resource"}
  # action :new, only: %w(index), on: :collection, position: :header, layout: :modal, click: {redirect_to: "new", open_in: :dialog}, submit: {post: "..", data: {:resource =>  ":resource"}, success: {close: :dialog, toast: :success}, error: {toast: :error, update: "components"}}
  # action :new_cancel, only: %w(new), on: :member,position: :footer, click: {close: :dialog}
  # action :create, only: %w(new), on: :member,position: :footer, click: {submit: "new_resource"}
  # action :destroy, only: %w(show), on: :member,position: :footer, layout: :modal, click: {delete: ".", confirm: true, success: {close: :dialog, toast: :success}, error: {toast: :error}}
  # action :sort, only: %w(), on: :collection, method: :post

  # Acts As User
  # Você pode definr que esse modelo deve agir como um usuário
  # Para isso utilize o metodo acts_as_user que pode receber um array de opções:
  # - database_authenticatable*
  # - registerable*
  # - recoverable*
  # - rememberable*
  # - trackable*
  # - invitable*
  # - token_authenticable
  # - confirmable
  # - lockable
  # - timeoutable
  # - omniauthable
  # ------------------------------------------------------------------------------
  # acts_as_user
  # acts_as_user :database_authenticatable, :invitable
  
  # Associations
  # Cada modelo pode se relacionar com os demais de várias formas
  # Esses relacionamentos são definidos dentro do bloco associations
  # ----------------------------------------------------------------
  associations do
  #   
  #   Tipos de associações possíveis
  #     - has_many: relacionamento 1 para N
  #     - has_one: relacionamento de 1 para 1
  #     - belongs_to: relacionamento de 1 para 1
  #     - has_and_belongs_to_many: relacionamento de N para N
  #   O nome da associação pode ser utilizado para reconhecer automaticamente o modelo
  #   Porém algumas opções de personalização podem ser passadas, como:
  #     - optional: usada no tipo belongs_to para que não seja obrigatório o relacionamento
  #     - class_name: para determinar uma classe diferente do nome da associação
  #     - inverse_of: para reconhecer o relacionamento inverso da outra classe
  #     - dependent: usado para criar uma relação de dependencia na exclusão
  #   -------------------------------------------------------------------------------------
  #   has_many :children_models
  #   has_one :children_model
  #   belongs_to :parent
  #   has_many :children_models, inverse_of: :parent
  #   belongs_to :parent, class_name: "ParentTest", inverse_of: :children_models, optional: true
  #   has_and_belongs_to_many :other_models
  end
  
  # Fieldsets
  # Utilize fieldsets para agrupar campos relacionados
  # Além do nome do grupo de campos, você pode incluir opções como:
  #   - header: para exibir o titulo do grupo de campos
  #   - tab: para transformar o grupo de campos em uma aba
  #   - size: para determinar o tamanho em colunas do grupo de campos
  #   - form_wizard: para transformar o grupo de campos em uma etapa de um form wizard
  #   - backend_if: condição de renderização no backend
  #   - render_if: condição de renderização no frontend
  #   - show_if: condição para exibir ou esconder no frontend 
  #   - styles: para sobrescrever os estilos padrão do nerdify
  # --------------------------------------------------------------------
  fieldset :resource do
  #
  #   Fields
  #   Dentro de um grupo de campos, você pode adicionar infinitos campos
  #   Se nenhuma opção for passada além do nome, o nome será usado para identificar o tipo automaticamente
  #   Existem vários tipos de campos, como:
  #     - avatar: imagem que representa um avatar de usuário
  #     - checkbox: campo de marcação do tipo check pode ser usado como booleano ou uma determinada string
  #     - cnpj: campo de texto padrão com validação de formato e mascara de CNPJ
  #     - code: editor de código fonte
  #     - color: seletor de cores no estilo colorpicker tradicional
  #     - cpf: campo de texto padrão com validação de formato e mascara de CPF
  #     - cpf_or_cnpj: campo de texto padrão com validação de formato e mascara para CPF e CNPJ
  #     - date: seletor de data no estilo datepicker tradicional
  #     - dete_time: seletor de dia e horario
  #     - decimal: numero com casas decimais
  #     - dropzone: area de upload de arquivos com opção drag and drop
  #     - editor: editor wysiwyg
  #     - html: para incluir conteúdo diretamente como inner HTML
  #     - money: representa valores monetários com validação de formato
  #     - month: seletor de mês
  #     - number: campos numericos inteiros
  #     - password: campo de senha padrão
  #     - radio: campo de marcação do tipo radiobutton para selecionar uma entre varias opcoes
  #     - select: campo de select para selecionar uma ou multiplas opcoes
  #     - text: campo de texto normal com apenas uma linha
  #     - textarea: campo de texto com multiplas linhas
  #     - time: campo para informar horario
  #     - week: seletor de semana
  #   Além de todos esses tipos predeterminados de campos você pode personaliza-los passando opções:
  #     - presence: para tornar campo obrigatório
  #     - uniqueness: para tornar campo único
  #     - format: para passar uma validação de formato personalizada usando expressões regulares
  #     - mask: aplica a mascara de formato no campo
  #     - inclusion: para determinar as unicas opções válidas que devem ser exibidas em selects, checkbox e radio
  #     - collection: para passar um path para buscar uma collection de objetos
  #     - multiple: para permitir multiplas seleções em select
  #     - accepted_files: para determinar tipos de arquivos aceitos nos anexos
  #     - upload: para definir um path de uma rota personalizada que vai receber os arquivos
  #     - label: para determinar se deve ou não exibir o label além do campo (default: true)
  #     - tags: select com opções que podem ser cadastradas para serem utilizadas posteriormanete
  #     - scope: usado para filtrar os objetos de uma determinada collection em um select
  #     - styles: para sobrescrever as opções de estilização do campo
  #     - default: valor padrão do campo caso não seja preenchido pelo usuário
  #     - size: determina o tamanho em colunas de 1 a 12
  #     - rows: para determinar o número de linhas de um textarea
  #     - render_if: condição para renderização no frontend
  #     - backend_if: condicional para renderização no backend
  #     - show_if: condicional para exibir ou esconder campo no frontend
  #     - validate_if: determina se o campo deve passar por uma validação ou não antes de salvar (default: true)
  #     - allow_blank: determina se o campo pode ser salvo em branco
  #     - min: determina um valor mínimo para o campo
  #     - max: determinar um valor máximo para o campo
  #     - eye: para incluir opção de exibir ou esconder o valor da senha
  #     - view: para determinar se é readonly, viewonly ou editable
  #     - layout: para determinar se inside, outside ou inline
  #   Alguns exemplos:
  #   -----------------------------------------------------------------------------------------------------
  #   field :name, presence: true
  #   field :expired?
  #   field :category, inclusion: %w(option1 option2 option3)
  #   field :dropzone_photo, type: :dropzone, accept_files: 'image/*', multiple: true
  #   field :decimal_field, type: :decimal, step: 0.01, max: 0.05
  #   field :custom_mask, mask: "000-000.000:00"
  #   field :checkbox_collection, multiple: true, type: :checkbox, collection: "/path_to_collection", filters: {scope: :scope_name}
  #   field :password_field, type: :password, eye: true
  #   field :test, layout: :inline, view: :readonly
  #   -----------------------------------------------------------------------------------------------------
  #   Embeds
  #   Você pode usar embeds para incorporar fieldsets, lists e outros componentes a partir de outros modelos
  #   Para isso deve existir as associações relacionadas aos embeds
  #   Além do nome, os embeds podem receber as seguintes opções
  #     - path: caminho para a collection que será incorporada
  #     - size: determina o tamanho em colunas de 1 a 12
  #     - allow_destroy: determina se os embeds podem ser removidos
  #     - add: determina se os embeds podem ser adicionados
  #     - remove: determina se os embeds podem ser removidos
  #     - include: determina se os embeds podem ser incluidos
  #     - form_object: determina o resource do objeto/modelo que será usado para criar o formulário embedado dinamicamente
  #     - questions: determina o nome do campo que contém as perguntas
  #     - options: determina o nome do campo que contém as opções
  #     - upload_path: determina o caminho para upload de arquivos de um form object
  #   Alguns exemplos:
  #   -----------------------------------------------------------------------------------------------------
  #   embed :checkin_answers, form_object: :checkin_form, questions: :form_questions_attributes, options: :form_question_options_attributes, upload_path: '/platform/beauty/beauty_services/upload'
  #   embed :feature_comments, path: 'feature_comments', size: 12, white_screen: true
  #   embed :form_question_options, add: true, remove: true, allow_destroy: true, include: true, size: 11
  end

  # Reports
  # Componente para gerar relatórios
  # Possui as mesmas opções de personalização mas no lugar de ter fields, tem charts
  # report :report_name, **options do
  #
  #   Chart
  #   Dentro de um report você pode ter infinitos charts
  #   Eles podem receber os atributos padrão de personalização do nerdify
  #   - size: para determinar o tamanho em colunas do grupo de campos
  #   - form_wizard: para transformar o grupo de campos em uma etapa de um form wizard
  #   - backend_if: condição de renderização no backend
  #   - render_if: condição de renderização no frontend
  #   - show_if: condição para exibir ou esconder no frontend 
  #   - styles: para sobrescrever os estilos padrão do nerdify
  #   Esses charts podem receber além do nome, e das opções padrão, outras opções de configuração do gráfico
  #   - type: determina o tipo de gráfico (pie, line, bar, etc)
  #   - data: pode ser um metodo que realiza a consulta e aggregation personalizados ou um objeto de configuração para o nerdify gerar como o abaixo:
  #       - resource: determina a collection que será consultada
  #       - scope: determina o scope do gráfico
  #       - where: condição de consulta, podendo utilizar valores do fieldset
  #       - lookup: determina quais associações devem ser buscadas
  #       - project: determina os valores que devem ser projetado
  #       - group: determina o agrupamento dos valores
  #       - value: determina o campo que contém o valor
  #   Alguns exemplos:
  #   -----------------------------------------------------------------------------------------------------
  #   chart :total_users1, type: :pie, data: {
  #     resource: "users",
  #     scope: :all,
  #     where: { :created_at.gte => "min_date", :created_at.lte => "max_date"},
  #     lookup: ["accounts"],
  #     project: {account_name: {"$first" => "$account.name"}},
  #     group: "$account_name",
  #     value: { "$sum" => 1 }
  #   }, size: 4, styles: {height: 100, vertical_align: {body: 'top'}}
  #   chart :total_users2, type: :line, data: {
  #     resource: "users",
  #     scope: :all,
  #     where: { :created_at.gte => "min_date", :created_at.lte => "max_date"},
  #     lookup: ["accounts"],
  #     project: {account_name: {"$first" => "$account.name"}},
  #     group: "$account_name",
  #     value: { "$sum" => 1 }
  #   },size: 4,  styles: {height: 100, vertical_align: {body: 'top'}}
  #   chart :total_users3, type: :line, labels: (1..7).to_a, data: {
  #     resource: "users",
  #     scope: :all,
  #     where: { :created_at.gte => "min_date", :created_at.lte => "max_date"},
  #     lookup: ["accounts"],
  #     project: {account_name: {"$first" => "$account.name"}, day: {"$dayOfWeek"=> "$created_at"}},
  #     group: [
  #         {
  #             _id: {account_name: "$account_name", day: "$day"},
  #             value: {"$sum" => 1}
  #         },
  #         {
  #             _id: "$_id.account_name",
  #             value: {"$push" => {_id: "$_id.day", value: "$value"}}
  #         }
  #     ],
  #     value: { "$sum" => 1 },
  #   }, size: 4, styles: {height: 100, vertical_align: {body: 'top'}}
  #   chart :total_users4, type: :bar, data: :custom_chart_method, labels: (1..31).to_a, size: 6,  styles: {height: 100, vertical_align: {body: 'top'}}
  # end
  # def custom_chart_method
  #   criteria = User.all.where({ :created_at.gte => min_date, :created_at.lte => max_date})
  #   pipeline = criteria.project({account_name: {"$first" => "$account.name"}, day: {"$dayOfMonth"=> "$created_at"}}).group({
  #       _id: {account_name: "$account_name", day: "$day"},
  #       value: {"$sum" => 1}
  #   }).group({
  #       _id: "$_id.account_name",
  #       value: {"$push" => {_id: "$_id.day", value: "$value"}}
  #   }).pipeline

  #   lookup = [{"$lookup" => { 
  #       from: 'accounts',
  #       localField: "account_id",
  #       foreignField: '_id',
  #       as: 'account'
  #   }}]   
  #   User.collection.aggregate(lookup+pipeline)
  # end

  # Filters
  # Você pode definir opções de campos de busca e filtros para objetos deste modelo
  # Algumas opções podem ser passadas nos filros:
  #   - submit_on_change: se setado para true, irá filtar os objetos a cada vez que um campo for mudado
  #   - submit_on_input: se setado para true, irá filtar os objetos a cada vez que um campo for digitado ou selecionado
  #   - backend_if: condição de renderização no backend
  #   - render_if: condição de renderização no frontend
  # -----------------------------------------------------------------------------------------------------
  filters :resource_filters, submit_on_input: true do
  #   Os campos inseridos no formulário de filtro são os mesmos do fieldset, com as mesmas opções
  #   Porém, no lugar de usar o método "field" para usar, no filtro você deve usar "add"
  #   Você pode utilizar um scopo do modelo como filtro
  #   E pode usar search com keywords para pesquisas fulltext
  #   Alguns exemplos:
  #   ___________________________________________________________________________________________
  #   add :search, type: :search, keywords: %w(name corporate_name), size: :xsmall
  #   add :categories, type: :select, collection: "RestaurantCategory", multiple: true, value: :name, size: :xsmall
  #   add :average_price, type: :select, inclusion: %w(to30 31to40 41to60 61to80 80to), size: :tiny
  #   add :scope, type: :checkbox, inclusion: %w(enabled disabled opened), inline: true, size: :small
  end
  
  # Lists
  # Você pode adicionar configuração de visualização em lista para o modelo nas telas de index
  # Uma lista pode receber algumas opções de personalização e tipos demonstrados abaixo.
  # Tipos e opções personalizadas:
  #   - table: Tabela padrão
  #       - thead: se setado para true, irá exibir o cabeçalho da tabela
  #       - sortable: se setado ativa ordenação drag and drop e determina a action que trata. Por padrão deve ser sortable: :sort
  #   - timeline: Linha do tempo
  #       - title: configuração do titulo do item
  #       - icon: configuração do icone do item
  #       - line: configuração da linha do item
  #   - kanban: Kanban de components
  #       - title: hash de opções de ação para quando soltar um item na lista
  #       - group: determina o campo que será usado para agrupar os itens
  #       - draggable: se setado para true, irá permitir arrastar e soltar os itens na lista
  #       - drop_item: hash de opções de ação para quando soltar um item na lista
  #       - column_height: Calculo de altura das colunas
  #       - sortable: se setado ativa ordenação drag and drop e determina a action que trata. Por padrão deve ser sortable: :sort
  #   - calendar: Fullcalendar
  #       - calendar_data: hash de opções de ação para quando soltar um item na lista
  #       - calendar_options: hash de opções de ação para quando soltar um item na lista
  #   - cards: Lista de cards
  #   - map: Mapa ***beta***
  #   - list: Lista de qualquer componente ***beta***
  # Opções gerais:
  #   - backend_if: condição de renderização no backend
  #   - render_if: condição de renderização no frontend
  #   - panel: se setado para true, irá exibir a lista dentro de um panel
  #   - click_item: hash de opções de ação para quando clicar no item
  #   - paginate: se setado para true, irá paginar a lista
  #   - paginate_per: quantidade de itens por pagina
  #   - size: determina o tamanho em colunas de 1 a 12
  #   - styles: estilos da lista
  #   - lookup: array de collections para lookup
  #   - add_fields: Exemplo: {stores_count: {"$size" => {"$ifNull" => ["$stores", []]}}}
  # Exemplos: 
  # -----------------------------------------------------------------------------------------------------
  #@@select_status = %w(one two three)
  #@@group = {
  #  by: :field,
  #  field: :select,
  #  columns: @@select_status,
  #  translate: true
  #}
  #@@drop_item = {put: ":resource.id", data: {component: {select: ":resource.select"}}, success: {toast: :success}, error: {toast: :error}}
  #@@drop_item = {redirect_to: ":resource.id/edit", open_in: :dialog}
  #@@drop_item = {
  #     if: {
  #         "this.resource.select == 'two'" => {redirect_to: ":resource.id/edit", params: {component: {select: ":resource.select", position: ":resource.position"}}, open_in: :dialog},
  #         "this.resource.select != 'two'" => {put: ":resource.id", data: {component: {select: ":resource.select"}, position: ":resource.position"}, success: {toast: :success}, error: {toast: :error}}
  #     }
  #}
  list :resource_table, type: :table, sortable: :sort, thead: true, paginate: true, paginate_per: 10 do
  #   add :photo_url
  #   add :id, sort: true
  #   add :textarea, sort: true
  #   add :date, sort: :created_at
  #   add :model_name, from: "$lookup_model.name"
  end
  # list :resource_timeline, type: :timeline, header: {html: "this.resource.date", size: 1}, title: "this.resource.id", icon: {name: 'this.resource.icon_info', background: 'this.resource.icon_color', color: 'white'}, line: {color: 'light', size: 2}, styles: {background: 'white', border: {top: 1, right: 1, left: 1, bottom: 1}, border_color: :light, rounded: {top_left: 1, top_right: 1, bottom_left: 1, bottom_right: 1}}, click_item: {redirect_to: ":resource.id"}, paginate: true, paginate_per: 10 do
  #   add :photo_url, component: :image, position: :left, image_size: 2, styles: {padding: {left: 2, right: 2, top: 2, bottom: 2}, rounded: {top_left: 2, top_right: 2, bottom_left: 2, bottom_right: 2}}
  #   add :id, component: :text, type: :small, styles:{color: :primary}, size: 12,styles: {color: :primary, padding: {left: 2, right: 2, top: 2, bottom: 0}}
  #   add :textarea, component: :text, type: :small, size: 12,styles: {padding: {left: 2, right: 2, top: 0, bottom: 0}}
  #   add :date, component: :text, type: :small,styles: {padding: {left: 2, right: 2, top: 0, bottom: 2}}
  # end
  # list :resource_kanban, type: :kanban, sortable: :sort, group: @@group, draggable: true, drop_item: @@drop_item, column_height: "calc(100vh -360px)" do
  #   add :photo_url, component: :image, position: :left, image_size: 2, styles: {padding: {left: 2, right: 2, top: 2, bottom: 2}, rounded: {top_left: 2, top_right: 2, bottom_left: 2, bottom_right: 2}}
  #   add :id, component: :text, type: :small, styles:{color: :primary}, size: 12,styles: {color: :primary, padding: {left: 2, right: 2, top: 2, bottom: 0}}
  #   add :textarea, component: :text, type: :small, size: 12,styles: {padding: {left: 2, right: 2, top: 0, bottom: 0}}
  #   add :date, component: :text, type: :small,styles: {padding: {left: 2, right: 2, top: 0, bottom: 2}}
  # end
  # list :resource_list, type: :cards, sortable: :sort, group: @@group, draggable: true, drop_item: @@drop_item, column_height: "calc(100vh -360px)" do
  #   add :photo_url, component: :image, position: :left, image_size: 2, styles: {padding: {left: 2, right: 2, top: 2, bottom: 2}, rounded: {top_left: 2, top_right: 2, bottom_left: 2, bottom_right: 2}}
  #   add :id, component: :text, type: :small, styles:{color: :primary}, size: 12,styles: {color: :primary, padding: {left: 2, right: 2, top: 2, bottom: 0}}
  #   add :textarea, component: :text, type: :small, size: 12,styles: {padding: {left: 2, right: 2, top: 0, bottom: 0}}
  #   add :date, component: :text, type: :small,styles: {padding: {left: 2, right: 2, top: 0, bottom: 2}}
  # end
  # list :resource_calendar, size: 12, type: :calendar, calendar_data: {title: :name, start: :date_time, end: :date_time}, calendar_options: {initialView: 'month', headerToolbar: {
  #     left: 'prev,next today',
  #     center: 'title',
  #     right: 'month,day,week' 
  # }}, styles: {margin: {top: 2, right: 2}}, click_item: {redirect_to: ":resource.id", open_in: :dialog} do
  # end
  # list :resource_cards, type: :cards, size: 12, card_size: 3, paginate: true, paginate_per: 20, click_item: {redirect_to: ":resource.id", open_in: :dialog}, styles: {vertical_align: {body: 'center'}} do
  #   add :customer_id_label, component: :text, type: :span, position: :top, size: 12, styles: {font_weight: 5, padding: {left: 2, right: 2, top: 1, bottom: 1}, margin: {bottom: 2}, border: {bottom: 1}, border_color: :light}
  #   add :photo_url, component: :image, position: :left, image_size: 2, styles: {margin: {left: 2, right: 1, top: 1, bottom: 1}, border: {top: 1, left: 1, right: 1, bottom: 1}, rounded: {top_left: 5, top_right: 5, bottom_left: 5, bottom_right: 5}}
  #   add :name, component: :text, type: :h6, styles: {color: :primary, font_weight: 5}, size: 12
  #   add :description, component: :text, type: :span, size: 12
  #   add :extra_info, component: :text, type: :span, size: 12
  #   add :characteristics, component: :html, size: 12, position: :bottom, styles: {margin: {top: 2}, padding: {top: 1, bottom: 1, left: 2, right: 2}, border: {top: 1}}
  # end
end