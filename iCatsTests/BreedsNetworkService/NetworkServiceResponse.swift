@testable import iCats
import Foundation

extension NetworkServiceResponse {
	
	public static func mock(data: Data, status: Int) -> Self {
		.success(
			(
				data,
				HTTPURLResponse(
					url: URL(string: "https://www.swordhealth.com")!,
					statusCode: status,
					httpVersion: nil,
					headerFields: nil
				)!
			)
		)
	}
	
	
}
