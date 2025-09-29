# Usa a imagem Heroku oficial como base
FROM heroku/heroku:22-build

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependência
COPY Gemfile Gemfile.lock ./

# Define o ENTRYPOINT da imagem Heroku.
# Isso garante que o ambiente (incluindo o Ruby e o Bundler) seja carregado.
# Isso deve resolver o problema "bundle: not found".
ENTRYPOINT ["/bin/bash", "-c"]

# Instala as dependências. Usamos o "sh -c" para garantir que o ENTRYPOINT seja executado.
# Mantenha o RUN como estava, mas a correção virá do ENTRYPOINT.
RUN bundle install --without development test

# Copia o restante da aplicação
COPY . .

# Define o comando de inicialização
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]