from distutils.core import setup
setup(
    name = 'inference',
    packages = ['inference', 'inference.pipeline', 'inference.providers'],
    version = '${VERSION}',
    license='MIT',
    description = 'Inference protobuf definition',
    author = 'Ciccio s.r.l.',
    author_email = 'francescodifranco90@gmail.com',
    url = 'https://gitlab.com/inference/inferenece-proto',
    keywords = ['protobuf'],
    install_requires=[
        'protobuf'
    ],
    classifiers=[
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
    ],
)