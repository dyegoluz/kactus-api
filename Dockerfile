# Usa a imagem Heroku oficial como base
FROM heroku/heroku:22-build

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos de dependência
COPY Gemfile Gemfile.lock ./

# --- A CORREÇÃO CRÍTICA ESTÁ AQUI ---
# Chamamos 'source /etc/profile.d/herokuish.sh' diretamente
# para carregar o ambiente Ruby e encontrar o 'bundle'
# ANTES de executar o bundle install.

RUN source /etc/profile.d/herokuish.sh && bundle install --without development test

# Copia o restante da aplicação
COPY . .

# Remove o ENTRYPOINT, que causava confusão. O Dokku o adiciona no final.
# Define o comando de inicialização
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]