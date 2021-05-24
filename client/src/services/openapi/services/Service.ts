/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import { request as __request } from '../core/request';

export class Service {

    /**
     * @param inputnumber2
     * @returns any
     * @throws ApiError
     */
    public static async test(
        inputnumber2: number,
    ): Promise<any> {
        const result = await __request({
            method: 'GET',
            path: `/getint/${inputnumber2}`,
            errors: {
                404: `\`inputnumber2\` not found`,
            },
        });
        return result.body;
    }

}