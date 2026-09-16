from PIL import Image
import os
def create_android_mipmaps(image_path, output_name='ic_launcher.png'):
    """
    Cria versões da imagem para diferentes densidades do Android
    """
    # Definições das pastas e tamanhos
    mipmaps = {
        'mipmap-mdpi': 48,      # baseline
        'mipmap-hdpi': 72,      # 1.5x
        'mipmap-xhdpi': 96,     # 2x
        'mipmap-xxhdpi': 144,   # 3x
        'mipmap-xxxhdpi': 192   # 4x
    }
    # Abrir imagem original
    try:
        img = Image.open(image_path)
        print(f"Imagem original carregada: {img.size}")
    except FileNotFoundError:
        print(f"Erro: Imagem '{image_path}' não encontrada!")
        return
    
    # Criar pastas e redimensionar imagens
    for folder, size in mipmaps.items():
        # Criar pasta se não existir
        if not os.path.exists(folder):
            os.makedirs(folder)
            print(f"Pasta '{folder}' criada!")
        
        # Calcular nova mantendo aspect ratio
        img_original = img.copy()
        
        # Determinar dimensões (assume que o maior lado será o tamanho especificado)
        width, height = img_original.size
        if width > height:
            new_width = size
            new_height = int(height * (size / width))
        else:
            new_height = size
            new_width = int(width * (size / height))
        
        # Redimensionar imagem
        img_resized = img_original.resize((new_width, new_height), Image.LANCZOS)
        
        # Salvar imagem
        output_path = os.path.join(folder, output_name)
        img_resized.save(output_path, 'PNG')
        print(f"✓ Salvo: {output_path} ({new_width}x{new_height})")

def create_android_drawables(image_path, output_name='splash.png'):
    """
    Cria versões da imagem para diferentes densidades do Android
    """
    
    # Definições das pastas e tamanhos
    drawables = {
        'drawable-mdpi': 480,      # baseline
        'drawable-hdpi': 720,      # 1.5x
        'drawable-xhdpi': 960,     # 2x
        'drawable-xxhdpi': 1440,   # 3x
        'drawable-xxxhdpi': 1920   # 4x
    }
    
    # Abrir imagem original
    try:
        img = Image.open(image_path)
        print(f"Imagem original carregada: {img.size}")
    except FileNotFoundError:
        print(f"Erro: Imagem '{image_path}' não encontrada!")
        return
    
    # Criar pastas e redimensionar imagens
    for folder, size in drawables.items():
        # Criar pasta se não existir
        if not os.path.exists(folder):
            os.makedirs(folder)
            print(f"Pasta '{folder}' criada!")
        
        # Calcular nova mantendo aspect ratio
        img_original = img.copy()
        
        # Determinar dimensões (assume que o maior lado será o tamanho especificado)
        width, height = img_original.size
        if width > height:
            new_width = size
            new_height = int(height * (size / width))
        else:
            new_height = size
            new_width = int(width * (size / height))
        
        # Redimensionar imagem
        img_resized = img_original.resize((new_width, new_height), Image.LANCZOS)
        
        # Salvar imagem
        output_path = os.path.join(folder, output_name)
        img_resized.save(output_path, 'PNG')
        print(f"✓ Salvo: {output_path} ({new_width}x{new_height})")

def create_android_drawables_fixed_size(image_path, output_name='splash.png'):
    """
    Versão alternativa: cria imagens com tamanho exato especificado
    (pode distorcer se o aspect ratio for diferente)
    """
    
    drawables = {
        'drawable-mdpi': (480, 480),
        'drawable-hdpi': (720, 720),
        'drawable-xhdpi': (960, 960),
        'drawable-xxhdpi': (1440, 1440),
        'drawable-xxxhdpi': (1920, 1920)
    }
    
    try:
        img = Image.open(image_path)
    except FileNotFoundError:
        print(f"Erro: Imagem '{image_path}' não encontrada!")
        return
    
    for folder, size in drawables.items():
        if not os.path.exists(folder):
            os.makedirs(folder)
        
        img_resized = img.resize(size, Image.LANCZOS)
        output_path = os.path.join(folder, output_name)
        img_resized.save(output_path, 'PNG')
        print(f"✓ Salvo: {output_path} ({size[0]}x{size[1]})")

# Uso
if __name__ == "__main__":
    # Substitua pelo caminho da sua imagem
    imagem_original = 'splash.png'  # ou "splash.png"
    
    # Criar drawables mantendo aspect ratio
    create_android_drawables(imagem_original, 'splash.png')

    create_android_mipmaps(imagem_original, 'ic_launcher.png')

    # OU usar tamanho fixo (descomente se preferir)
    # create_android_drawables_fixed_size(imagem_original, 'splash.png')