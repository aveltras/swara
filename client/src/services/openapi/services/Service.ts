/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import { request as __request } from '../core/request';

export class Service {

    /**
     * @param int
     * @returns any
     * @throws ApiError
     */
    public static async test(
        int: number,
    ): Promise<any> {
        const result = await __request({
            method: 'GET',
            path: `/getint/${int}`,
            errors: {
                404: `int not found`, 
            },
        });
        return result.body;
    }

}
