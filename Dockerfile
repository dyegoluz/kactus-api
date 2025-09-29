# Use uma imagem Heroku oficial como base para melhor compatibilidade com Ruby/Rails
FROM heroku/heroku:22-build

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependência
COPY Gemfile Gemfile.lock ./

# Instala as dependências (sem ambientes de dev/test)
# ATENÇÃO: Se seu build falhar aqui por falta de memória, este é o momento crítico.
RUN bundle install --without development test

# Copia o restante da aplicação
COPY . .

# Define o comando de inicialização (como no Procfile original)
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]