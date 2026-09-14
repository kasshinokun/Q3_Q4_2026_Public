#!/bin/bash
# ====================================================================================================================
# Script de Instalação e Configuração de Ambientes de Desenvolvimento
# Otimizado para: Tsurugi Linux 26.03 x64 (Base Ubuntu/Debian)
# ====================================================================================================================

set -e  # Interrompe o script em caso de erro
export DEBIAN_FRONTEND=noninteractive

# Cores para saída (opcional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sem cor

log() {
    echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"
}

error() {
    echo -e "${RED}[ERRO]${NC} $1" >&2
    exit 1
}

warn() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

# ====================================================================================================================
# [1/6] Atualização e Dependências Base
# ====================================================================================================================
stage_1(){
    log "Atualizando sistema e instalando dependências essenciais..."

    sudo apt-get install wget gnupg -y

    wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /usr/share/keyrings/deb.torproject.org-keyring.gpg >/dev/null

    wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/deb.torproject.org.gpg >/dev/null

    sudo apt-get clean

    sudo apt-get update -qq
    sudo apt-get upgrade -y -qq

    # Agrupamento de pacotes (evita múltiplas chamadas apt)
    PACKAGES=(
        build-essential
        libssl-dev zlib1g-dev libncurses5-dev libgdbm-dev libncursesw5-dev
        libreadline-dev libsqlite3-dev libffi-dev uuid-dev liblzma-dev tk-dev
        curl git unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config
        libgtk-3-dev libstdc++6 software-properties-common apt-transport-https
        default-jdk openjdk-21-jdk   # Apenas a versão LTS mais recente
    )

    sudo apt-get install -y -qq "${PACKAGES[@]}"

    # Habilita arquitetura i386 (necessário para Android SDK)
    sudo dpkg --add-architecture i386
    sudo apt-get update -qq
    sudo apt-get install -y -qq libc6:i386 libncurses6:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
}

# ====================================================================================================================
# [2/6] Python 3.14.7 via uv (rápido e leve)
# ====================================================================================================================
stage_2(){
    log "Instalando Python 3.14.7 via uv..."

    # Verifica se curl está presente
    if ! command -v curl &> /dev/null; then
        error "curl não encontrado. Instale-o manualmente."
    fi

    # Instala o uv (gerenciador de Python)
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Adiciona uv ao PATH da sessão atual
    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

    # Instala a versão específica do Python
    uv python install 3.14.7

    # Verifica a instalação
    if command -v python3.14 &> /dev/null; then
        python3.14 --version
    else
        error "Python 3.14.7 não foi instalado corretamente."
    fi
}
# ====================================================================================================================
# [3/6] Java e C/C++ (verificação)
# ====================================================================================================================
stage_3(){

    log "Versões instaladas:"
    java --version || warn "Java não encontrado no PATH"
    gcc --version | head -1
    g++ --version | head -1

}
# ====================================================================================================================
# [4/6] C# / .NET 10
# ====================================================================================================================
stage_4(){
    log "Instalando .NET 10 SDK..."
    dotnet_microsoft(){
        # Baixa e executa o instalador oficial
        # =============== OBS. IMPORTANTE: ======================
        # O .NET 10 pode não estar nos repositórios padrão do apt.
        # O script oficial da Microsoft é o mais seguro e preciso.
#!/bin/bash
# ====================================================================================================================
# Script de Instalação e Configuração de Ambientes de Desenvolvimento
# Otimizado para: Tsurugi Linux 26.03 x64 (Base Ubuntu/Debian)
# ====================================================================================================================

set -e  # Interrompe o script em caso de erro
export DEBIAN_FRONTEND=noninteractive

# Cores para saída (opcional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sem cor

log() {
    echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"
}

error() {
    echo -e "${RED}[ERRO]${NC} $1" >&2
    exit 1
}

warn() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

# ====================================================================================================================
# [1/6] Atualização e Dependências Base
# ====================================================================================================================
stage_1(){
    log "Atualizando sistema e instalando dependências essenciais..."

    sudo apt-get install wget gnupg -y

    wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /usr/share/keyrings/deb.torproject.org-keyring.gpg >/dev/null

    wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/deb.torproject.org.gpg >/dev/null

    sudo apt-get clean

    sudo apt-get update -qq
    sudo apt-get upgrade -y -qq

    # Agrupamento de pacotes (evita múltiplas chamadas apt)
    PACKAGES=(
        build-essential
        libssl-dev zlib1g-dev libncurses5-dev libgdbm-dev libncursesw5-dev
        libreadline-dev libsqlite3-dev libffi-dev uuid-dev liblzma-dev tk-dev
        curl git unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config
        libgtk-3-dev libstdc++6 software-properties-common apt-transport-https
        default-jdk openjdk-21-jdk   # Apenas a versão LTS mais recente
    )

    sudo apt-get install -y -qq "${PACKAGES[@]}"

    # Habilita arquitetura i386 (necessário para Android SDK)
    sudo dpkg --add-architecture i386
    sudo apt-get update -qq
    sudo apt-get install -y -qq libc6:i386 libncurses6:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
}

# ====================================================================================================================
# [2/6] Python 3.14.7 via uv (rápido e leve)
# ====================================================================================================================
stage_2(){
    log "Instalando Python 3.14.7 via uv..."

    # Verifica se curl está presente
    if ! command -v curl &> /dev/null; then
        error "curl não encontrado. Instale-o manualmente."
    fi

    # Instala o uv (gerenciador de Python)
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Adiciona uv ao PATH da sessão atual
    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

    # Instala a versão específica do Python
    uv python install 3.14.7

    # Verifica a instalação
    if command -v python3.14 &> /dev/null; then
        python3.14 --version
    else
        error "Python 3.14.7 não foi instalado corretamente."
    fi
}
# ====================================================================================================================
# [3/6] Java e C/C++ (verificação)
# ====================================================================================================================
stage_3(){

    log "Versões instaladas:"
    java --version || warn "Java não encontrado no PATH"
    gcc --version | head -1
    g++ --version | head -1

}
# ====================================================================================================================
# [4/6] C# / .NET 10
# ====================================================================================================================
stage_4(){
    log "Instalando .NET 10 SDK..."
    dotnet_microsoft(){
        # Baixa e executa o instalador oficial
        # =============== OBS. IMPORTANTE: ======================
        # O .NET 10 pode não estar nos repositórios padrão do apt.
        # O script oficial da Microsoft é o mais seguro e preciso.

        curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
        chmod +x /tmp/dotnet-install.sh
        /tmp/dotnet-install.sh --channel 10.0 --install-dir /usr/share/dotnet
        sudo ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet
        rm -f /tmp/dotnet-install.sh

        # Recarrega o PATH para usar o dotnet imediatamente
        export PATH="/usr/share/dotnet:$PATH"

    }
    dotnet_apt(){
        # No Tsurugi 26.03 x64, o .NET 10 está nos repositórios padrão do apt,
        # ainda que o script oficial da Microsoft seja o mais seguro e preciso.
        sudo apt-get install dotnet-sdk-10.0

    }

    dotnet_apt # .NET 10 a partir dos repositórios padrão do apt
    # Instala o template do Avalonia
    dotnet new install Avalonia.Templates

    dotnet --version
}
# ====================================================================================================================
# [5/6] Flutter (via git)
# ====================================================================================================================
stage_5a(){
    log "Instalando Flutter (stable)..."

    FLUTTER_DIR="$HOME/development/flutter"
    mkdir -p "$(dirname "$FLUTTER_DIR")"

    if [ -d "$FLUTTER_DIR" ]; then
        log "Atualizando Flutter existente..."
        cd "$FLUTTER_DIR"
        git pull origin stable
    else
        cd "$(dirname "$FLUTTER_DIR")"
        git clone https://github.com/flutter/flutter.git -b stable
    fi
}

stage_5b(){

    FLUTTER_DIR="$HOME/development/flutter"

    # Adiciona ao PATH permanentemente e na sessão atual
    if ! grep -q "development/flutter/bin" ~/.bashrc; then
        log "Adicionando ao PATH"
        echo 'export PATH="$PATH:$FLUTTER_DIR/bin"' >> ~/.bashrc
    fi

    log "Adicionando ao Environment"
    #export PATH="$PATH:$HOME/development/flutter/bin"
    export PATH="$PATH:$FLUTTER_DIR/bin"

    log "Atualizando BASH"
    source ~/.bashrc

}
stage_5c(){
    log"Baixando Dart SDK...."
    flutter --version
}

stage_5(){ # Flutter e Dart SDK

    # stage_5a # Instalação Flutter

    # stage_5b # Finalização Flutter

    stage_5c # instalação Dart SDK
}

# ====================================================================================================================
# [6/6] Android Studio e Licenças
# ====================================================================================================================
stage_6b1(){ # Dicas para configurar o Android SDK - 13/09/2026 revisão 14-09-2026-2

    log "Instruçoes para configurar o Android SDK"

    log "Instalando SDK e cmdline-tools via Android Studio"

    log "Passo 1: Abra o Android Studio."
    log "        Rode no terminal 'android-studio'" 
    log "Passo 2: Abra o SDK Manager:"

    log "  A) Na tela de boas-vindas:"
    log "        Clique em More Actions (ou no ícone de três pontos)"
    log "        Clique em SDK Manager."

    log "  B) Com um projeto aberto:"
    log "        Vá em Tools"
    log "        SDK Manager (ou Settings/Preferences)"
    log "        Languages ​​& Frameworks"
    log "        Android SDK"

    log "Passo 3: Selecione a aba SDK Platforms na parte superior."
    log "        Marque todos os android sdk do 8.0 até o atual[17] (em 14-09-2026, do 29.0 ao 37.0)"
    log "Passo 4: Selecione a aba SDK Tools na parte superior."
    
    log "Passo 5: Procure por Android SDK Command-line Tools (latest) e marque a caixa de seleção ao lado."

    log "Passo 6: Clique em Apply no canto inferior direito."

    log "Passo 7: Clique em OK para confirmar o download e aguarde a conclusão da instalação."

    log "Apos isto, é somente rodar no terminal 'flutter doctor --android-licenses'"
}
stage_6b2(){ # Configurar o Android SDK - 13/09/2026 revisão 14-09-2026-2

    log "Configure o Android SDK"

    android-studio
    # O comando 'android-studio' abre a GUI e trava o script em background/terminal.
    # Enquanto o sdk do android é configurado


    # Aceitação automática das licenças do Android SDK
    log "Aceitando licenças do Android SDK (pode levar alguns minutos)..."
    yes | flutter doctor --android-licenses || warn "Falha ao aceitar licenças. Execute 'flutter doctor --android-licenses' manualmente."

    # Executa o flutter doctor para verificar o ambiente
    flutter doctor
}

stage_6(){ # Android Studio 13/09/2026 revisão 14-09-2026-2

    stage_6a # Instalação

    stage_6b1 # Dicas

    stage_6b2 # Finalização

}
# ====================================================================================================================
# Finalização
# ====================================================================================================================
stage_final(){
    log "✅ Ambiente configurado com sucesso!"
    log "Para aplicar as variáveis de ambiente na sessão atual, execute:"
    echo "    source ~/.bashrc"
    log "Ou reinicie o terminal."
}


stage_6

        curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
        chmod +x /tmp/dotnet-install.sh
        /tmp/dotnet-install.sh --channel 10.0 --install-dir /usr/share/dotnet
        sudo ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet
        rm -f /tmp/dotnet-install.sh

        # Recarrega o PATH para usar o dotnet imediatamente
        export PATH="/usr/share/dotnet:$PATH"

    }
    dotnet_apt(){
        # No Tsurugi 26.03 x64, o .NET 10 está nos repositórios padrão do apt,
        # ainda que o script oficial da Microsoft seja o mais seguro e preciso.
        sudo apt-get install dotnet-sdk-10.0

    }

    dotnet_apt # .NET 10 a partir dos repositórios padrão do apt
    # Instala o template do Avalonia
    dotnet new install Avalonia.Templates

    dotnet --version
}
# ====================================================================================================================
# [5/6] Flutter (via git)
# ====================================================================================================================
stage_5a(){
    log "Instalando Flutter (stable)..."

    FLUTTER_DIR="$HOME/development/flutter"
    mkdir -p "$(dirname "$FLUTTER_DIR")"

    if [ -d "$FLUTTER_DIR" ]; then
        log "Atualizando Flutter existente..."
        cd "$FLUTTER_DIR"
        git pull origin stable
    else
        cd "$(dirname "$FLUTTER_DIR")"
        git clone https://github.com/flutter/flutter.git -b stable
    fi
}

stage_5b(){

    FLUTTER_DIR="$HOME/development/flutter"

    # Adiciona ao PATH permanentemente e na sessão atual
    if ! grep -q "development/flutter/bin" ~/.bashrc; then
        log "Adicionando ao PATH"
        echo 'export PATH="$PATH:$FLUTTER_DIR/bin"' >> ~/.bashrc
    fi

    log "Adicionando ao Environment"
    #export PATH="$PATH:$HOME/development/flutter/bin"
    export PATH="$PATH:$FLUTTER_DIR/bin"

    log "Atualizando BASH"
    source ~/.bashrc

}
stage_5c(){
    log"Baixando Dart SDK...."
    flutter --version
}

stage_5(){ # Flutter e Dart SDK

    stage_5a # Instalação Flutter

    stage_5b # Finalização Flutter

    stage_5c # instalação Dart SDK
}

# ====================================================================================================================
# [6/6] Android Studio e Licenças
# ====================================================================================================================
stage_6a(){
    log "Instalando Android Studio..."

    # Snap
    android_studio_snap(){
        # Verifica se snap está disponível; caso contrário, baixa o tarball
        if command -v snap &> /dev/null; then
            sudo snap install android-studio --classic
        else
            warn "Snap não encontrado."
        fi
    }
    # Manual
    android_studio_manual(){
        warn "Fazendo download manual do Android Studio..."
        ANDROID_STUDIO_URL="https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.4.7/android-studio-quail4-linux.tar.gz"

        # -q ---------------> Silenciosamente
        # --show-progress --> Exibe progresso do download
        # -O ---------------> Especifica o arquivo a ser salvo

        # wget -q --show-progress "$ANDROID_STUDIO_URL" -O /tmp/android-studio.tar.gz

        wget --show-progress "$ANDROID_STUDIO_URL" -O /tmp/android-studio.tar.gz

        sudo tar -xzf /tmp/android-studio.tar.gz -C /opt/
        sudo ln -sf /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio
        rm -f /tmp/android-studio.tar.gz
    }

    android_studio_manual # No momento, sera manual
}

stage_6b(){
    log "Configure o Android SDK"

    android-studio
    # O comando 'android-studio' abre a GUI e trava o script em background/terminal.
    # Enquanto o sdk do android é configurado


    # Aceitação automática das licenças do Android SDK
    log "Aceitando licenças do Android SDK (pode levar alguns minutos)..."
    yes | flutter doctor --android-licenses || warn "Falha ao aceitar licenças. Execute 'flutter doctor --android-licenses' manualmente."

    # Executa o flutter doctor para verificar o ambiente
    flutter doctor
}

stage_6(){ # Android Studio 13/09/2026

    stage_6a # Instalação

    stage_6b # Finalização

}
# ====================================================================================================================
# Finalização
# ====================================================================================================================
stage_final(){
    log "✅ Ambiente configurado com sucesso!"
    log "Para aplicar as variáveis de ambiente na sessão atual, execute:"
    echo "    source ~/.bashrc"
    log "Ou reinicie o terminal."
}
stage_1

stage_2

stage_3

stage_4

stage_5

stage_6

stage_final
