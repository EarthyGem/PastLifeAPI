import Vapor
import NIOSSL

public func configure(_ app: Application) throws {
    app.logger.info("Starting configuration")

    let certPath = "/Users/administrator/pastlifeapi/lilaastrology.com.crt"
    let keyPath = "/Users/administrator/pastlifeapi/lilaastrology.com.key"

    app.logger.info("Using certPath: \(certPath)")
    app.logger.info("Using keyPath: \(keyPath)")

    do {
        let certificates = try NIOSSLCertificate.fromPEMFile(certPath)
        let privateKey = try NIOSSLPrivateKey(file: keyPath, format: .pem)

        app.logger.info("Certificates and private key successfully loaded")

        let configuration = TLSConfiguration.makeServerConfiguration(
            certificateChain: certificates.map { .certificate($0) },
            privateKey: .privateKey(privateKey)
        )

        app.http.server.configuration.tlsConfiguration = configuration
    } catch {
        app.logger.critical("Failed to load SSL certificates: \(error)")
        throw error
    }

    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 443

    // Register routes
    try routes(app)
}
