import os
import argparse
import subprocess
from multiprocessing import Pool


def download_file(file):
    url = f"https://cn01.mmai.io/download/voxceleb?key=9fe77f1bca208ff26a888fd3e717c4a10ddb998cc5176767a8a62bfd8d1047854ffeaad8d4aa52b2877ef2122966b28d92db1cd693aaaf1541fd6d28e20299684e549cf2f6f1cb4ddcc6df810822f0d71d4c3517be9c68faae8158ee276a6d6e932b8a0fbbbe87f8f7322d3dcd9d9a81ba89ceecb2f87f2036e439ab2df69b5f&file={file}"
    subprocess.run(['wget', '--no-check-certificate', '-O', file, url], check=True)

def run_command(cmd):
    subprocess.run(cmd, shell=True, check=True)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Download and process VoxCeleb datasets.')
    parser.add_argument('--dataset', type=str, required=True, choices=["1", "2"], help='VoxCeleb dataset ID: 1 or 2')
    args = parser.parse_args()

    datasets = {
        "1": {
            "urls": ['vox1_dev_wav_partaa', 'vox1_dev_wav_partab', 'vox1_dev_wav_partac', 'vox1_dev_wav_partad', 'vox1_test_wav'],
            "dev_file": "vox1_dev_wav.zip",
            "test_file": "vox1_test_wav.zip"
        },
        "2": {
            "urls": ['vox2_dev_aac_partaa', 'vox2_dev_aac_partab', 'vox2_dev_aac_partac', 'vox2_dev_aac_partad', 'vox2_dev_aac_partae', 'vox2_dev_aac_partaf', 'vox2_dev_aac_partag', 'vox2_dev_aac_partah', 'vox2_test_aac'],
            "dev_file": "vox2_dev_aac.zip",
            "test_file": "vox2_test_aac.zip"
        }
    }

    dataset = args.dataset
    if dataset not in datasets:
        raise Exception(f"Error: Dataset id {dataset} not valid!")
    else:
        print(f"Downloading and processing VoxCeleb{dataset}...")

    data = datasets[dataset]
    vox_urls = data["urls"]
    dev_file = data["dev_file"]
    test_file = data["test_file"]

    # Default path
    dir_path = f"/export/corpora/VoxCeleb{dataset}"
    os.makedirs(dir_path, exist_ok=True)
    os.chdir(dir_path)

    with Pool() as p:
        p.map(download_file, vox_urls)

    print(f"\nDownload VoxCeleb{dataset} done! Now processing it...")
    for cmd in [
        f"cat {dev_file.split('.')[0]}_part* > {dev_file}",
        f"rm {dev_file.split('.')[0]}_part*",
        f"unzip -qq {dev_file} -d dev" if dataset == "1" else f"unzip -qq {dev_file}",
        f"unzip -qq {test_file} -d test",
        f"rm {dev_file} {test_file}"
    ]:
        print(f"Running: {cmd}")
        run_command(cmd)
