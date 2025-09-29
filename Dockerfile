# Usa a imagem Heroku oficial como base
FROM heroku/heroku:22-build

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependência
COPY Gemfile Gemfile.lock ./

# --- CORREÇÃO: ENTRYPOINT para carregar o ambiente (necessário para o "bundle" ser encontrado) ---
# Usamos o ENTRYPOINT padrão que o herokuish/Dokku usaria para carregar o ambiente.
# Isso garante que o PATH e o RVM/rbenv sejam configurados.
ENTRYPOINT ["/bin/bash", "-c", "source /etc/profile.d/herokuish.sh && exec \"$@\""]

# Instala as dependências.
# A diferença agora é que o ENTRYPOINT deve garantir que o "bundle" seja encontrado.
RUN bundle install --without development test

# Copia o restante da aplicação
COPY . .

# Define o comando de inicialização
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]