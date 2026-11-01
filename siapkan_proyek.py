"""Jalankan: python siapkan_proyek.py (Flutter SDK harus sudah di PATH)."""
from pathlib import Path
import shutil
import subprocess
import sys

source = Path(__file__).resolve().parent
target = source.parent / 'tugas03_crypto'
flutter = shutil.which('flutter')
if not flutter:
    sys.exit('Flutter belum ditemukan. Pasang Flutter SDK dan tambahkan ke PATH.')
if target.exists():
    sys.exit(f'Folder {target} sudah ada. Pindahkan/ubah namanya terlebih dahulu agar tidak tertimpa.')
subprocess.run([flutter, 'create', '--platforms=android,ios', '--project-name',
                'tugas03_crypto', str(target)], check=True)
for name in ('lib', 'test'):
    shutil.rmtree(target / name)
    shutil.copytree(source / name, target / name)
shutil.copy2(source / 'pubspec.yaml', target / 'pubspec.yaml')
shutil.copy2(source / 'android/app/src/main/AndroidManifest.xml',
             target / 'android/app/src/main/AndroidManifest.xml')
shutil.copy2(source / 'PENJELASAN.md', target / 'PENJELASAN.md')
subprocess.run([flutter, 'pub', 'get'], cwd=target, check=True)
print(f'Proyek siap: {target}\nMasuk ke folder tersebut, kemudian jalankan flutter run.')
