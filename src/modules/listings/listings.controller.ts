import { Controller, Get, Post, Body, Patch, Param, Delete, Query, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { ListingsService } from './listings.service';
import { CreateListingDto, UpdateListingDto } from './dto';

@ApiTags('Listings')
@Controller('listings')
export class ListingsController {
    constructor(private readonly listingsService: ListingsService) { }

    @Post()
    @ApiOperation({ summary: 'Create a new listing' })
    create(@Body() createListingDto: CreateListingDto) {
        return this.listingsService.create(createListingDto);
    }

    @Get()
    @ApiOperation({ summary: 'Get all listings' })
    @ApiQuery({ name: 'limit', required: false })
    @ApiQuery({ name: 'offset', required: false })
    findAll(@Query('limit') limit?: number, @Query('offset') offset?: number) {
        return this.listingsService.findAll(limit, offset);
    }

    @Get('search')
    @ApiOperation({ summary: 'Search listings' })
    @ApiQuery({ name: 'q', required: true })
    search(@Query('q') query: string) {
        return this.listingsService.search(query);
    }

    @Get('seller/:sellerId')
    @ApiOperation({ summary: 'Get listings by seller' })
    findBySeller(@Param('sellerId') sellerId: string) {
        return this.listingsService.findBySeller(sellerId);
    }

    @Get('category/:categoryId')
    @ApiOperation({ summary: 'Get listings by category' })
    findByCategory(@Param('categoryId') categoryId: string) {
        return this.listingsService.findByCategory(categoryId);
    }

    @Get(':id')
    @ApiOperation({ summary: 'Get listing by ID' })
    findOne(@Param('id') id: string) {
        return this.listingsService.findOne(id);
    }

    @Patch(':id')
    @ApiOperation({ summary: 'Update listing' })
    update(@Param('id') id: string, @Body() updateListingDto: UpdateListingDto) {
        return this.listingsService.update(id, updateListingDto);
    }

    @Delete(':id')
    @HttpCode(HttpStatus.NO_CONTENT)
    @ApiOperation({ summary: 'Delete listing' })
    remove(@Param('id') id: string) {
        return this.listingsService.remove(id);
    }
}
